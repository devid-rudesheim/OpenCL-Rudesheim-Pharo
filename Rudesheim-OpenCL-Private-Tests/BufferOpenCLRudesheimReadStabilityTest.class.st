"
A BufferOpenCLRudesheimReadStabilityTest probes whether a BufferOpenCLRudesheim's content stays
reliable to read back after being used as a GPU kernel argument, as opposed to just created and
released once. This exists because of an investigation recorded in note/pharo-ops.md 34節: a
persistent buffer (uploaded once, never recreated) that is read by many separate kernel launches
over time used to unreliably return stale/garbage content on a later host-side read, at an
observed rate of roughly 40-57% over 300 trials, while the same buffer read purely host-side (no
kernel involved) or a buffer pattern where every buffer is freshly created and released within its
own trial were both overwhelmingly reliable. The root cause turned out to be a genuine
use-after-free in this codebase, not a native/driver defect: ContextOpenCLRudesheim>>
newCLBufferWithFloats:/newCLBufferWithDoubles: created the CL_MEM_USE_HOST_PTR-backing host memory
via ExternalAddress class>>gcallocate: (freed as soon as its wrapper is unreachable) without
retaining any Smalltalk-side reference to it past buffer creation. Fixed by backing these buffers
with a ByteArray retained on the buffer object itself for the buffer's lifetime (see
BufferOpenCLRudesheim>>hostByteArray:) -- verified via testRepeatedKernelReadsOfPersistentBuffer,
below, which used to be an unconditionally-skipped diagnostic and is now a real regression test.
"
Class {
	#name : 'BufferOpenCLRudesheimReadStabilityTest',
	#superclass : 'BasicRudesheimTest',
	#instVars : [
		'clContext'
	],
	#category : 'Rudesheim-OpenCL-Private-Tests-Objects',
	#package : 'Rudesheim-OpenCL-Private-Tests',
	#tag : 'Objects'
}

{ #category : 'accessing' }
BufferOpenCLRudesheimReadStabilityTest class >> targetClass [

	^ BufferOpenCLRudesheim.
]

{ #category : 'accessing' }
BufferOpenCLRudesheimReadStabilityTest >> clContext [

	^ clContext
		ifNil:
		[
			clContext :=
				ContextOpenCLRudesheim
					clContextFor:	Rudesheim OpenCL Platform clPlatforms first clDevices.
		].

]

{ #category : 'accessing' }
BufferOpenCLRudesheimReadStabilityTest >> defaultBasicTarget [

	^ self clContext
		newCLBufferForSize:	16r10
		options:
		{
			Rudesheim OpenCL ReadWrite.
		}.
]

{ #category : 'accessing' }
BufferOpenCLRudesheimReadStabilityTest >> clQueue [

	^ self clContext
		newCLCommandQueueFor:	Rudesheim OpenCL Platform clPlatforms first clDevices first.
]

{ #category : 'accessing' }
BufferOpenCLRudesheimReadStabilityTest >> identityKernel [
	"A minimal one-argument-in-one-argument-out kernel (output[i] := input[i])
	-- deliberately not one of the production Conv2D/Gemv/etc. kernels, so
	these tests stay independent of note/resnet50-onnx-support-plan.md's
	kernel source and don't share a program/kernel cache entry with it."

	^ self identityKernelProgram
		newCLKernelAt:	'CopyIdentityRudesheimReadStabilityTest'
		withParameterTypes:
		{
			TFBasicType pointer.
			TFBasicType pointer.
		}.
]

{ #category : 'accessing' }
BufferOpenCLRudesheimReadStabilityTest >> identityKernelProgram [

	^ self clContext
		buildCLProgramFor:	Rudesheim OpenCL Platform clPlatforms first clDevices
		fromSources:
		{
			'
kernel void CopyIdentityRudesheimReadStabilityTest(global const float* input, global float* output)
{
	uint i = get_global_id(0);
	output[i] = input[i];
}
'
		}
		withOptions:	''.
]

{ #category : 'tests' }
BufferOpenCLRudesheimReadStabilityTest >> testPureHostReadsOfPersistentBufferAreStable [
	"Control case: repeatedly re-reading a buffer that is never rewritten or
	recreated is safe when done purely host-side (map/read only, no kernel
	involved). This isolates the actual defect (note/pharo-ops.md 34節) to
	kernel reads specifically, not to buffer persistence by itself."
	|
		queue
		expectedValues
		buffer
	|

	queue := self clQueue.
	expectedValues := #( 1.0 2.0 3.0 4.0 5.0 6.0 7.0 8.0 ).
	buffer := self clContext newCLBufferWithFloats: expectedValues.

	50 timesRepeat:
	[
		self
			assert:	( queue readFloatsFrom: buffer count: 8 )
			equals:	expectedValues.
	].

	buffer release.
	queue release.
]

{ #category : 'tests' }
BufferOpenCLRudesheimReadStabilityTest >> testFreshBuffersRoundTripThroughIdentityKernelReliably [
	"The safe pattern: a fresh input+output buffer pair created, used, and
	released within each trial round-trips through a real GPU kernel
	reliably. This is the pattern every OpenCL Layer forward: already
	follows for its own inputBuffer/outputBuffer -- see
	note/pharo-ops.md 34節 for why this matters (a persistent buffer read by
	many separate kernel launches, by contrast, is unreliable)."
	|
		queue
		expectedValues
		kernel
		trialCount
		failureCount
	|

	queue := self clQueue.
	expectedValues := #( 1.0 2.0 3.0 4.0 5.0 6.0 7.0 8.0 ).
	kernel := self identityKernel.
	trialCount := 60.
	failureCount := 0.

	trialCount timesRepeat:
	[
		|
			inputBuffer
			outputBuffer
			kernelEvent
		|

		inputBuffer := self clContext newCLBufferWithFloats: expectedValues.
		outputBuffer := self clContext newCLBufferForSize: 8 * TFBasicType float byteSize.

		kernelEvent :=
			queue
				enqueueKernel:	kernel
				forNDRange:				{ { 8 } }
				withArguments:			{ inputBuffer. outputBuffer }.
		kernelEvent wait.
		kernelEvent release.

		( ( queue readFloatsFrom: outputBuffer count: 8 ) = expectedValues )
			ifFalse: [ failureCount := failureCount + 1 ].

		inputBuffer release.
		outputBuffer release.
	].

	"A tiny nonzero baseline (observed ~0.3%, i.e. roughly 1 in 300) is
	tolerated here -- see note/pharo-ops.md 34節 -- but a fresh-buffer-per-
	trial pattern should stay overwhelmingly reliable."
	self
		assert:	failureCount <= 2
		description:
			'fresh-buffer round trip failed ', failureCount printString,
			'/', trialCount printString,
			' times -- see note/pharo-ops.md 34節'.

	kernel release.
	queue release.
]

{ #category : 'tests' }
BufferOpenCLRudesheimReadStabilityTest >> testRepeatedKernelReadsOfPersistentBufferAreReliable [
	"Regression test for the use-after-free fixed in ContextOpenCLRudesheim>>
	newCLBufferWithFloats:/newCLBufferWithDoubles: and BufferOpenCLRudesheim>>hostByteArray: --
	see note/pharo-ops.md 34節. Before the fix this failed at roughly 40-57% over 300 trials
	(and this specific reproduction was verified at 0/300, including under an explicit
	Smalltalk garbageCollect forced on every single trial, once fixed); before that, an
	earlier attempt at fixing this by switching CL_MEM_USE_HOST_PTR to CL_MEM_COPY_HOST_PTR
	alone (without also retaining a Smalltalk-side reference to the host memory) measured no
	improvement, confirming the missing reference -- not the CL_MEM_* flag choice -- was the
	actual defect. A buffer that is uploaded ONCE and then read by many separate kernel
	launches (never recreated in between) must return the same, correct content every time,
	same as the fresh-buffer-per-trial pattern in testFreshBuffersRoundTripThroughIdentityKernelReliably."

	self runRepeatedKernelReadsOfPersistentBufferDiagnostic.
]

{ #category : 'private' }
BufferOpenCLRudesheimReadStabilityTest >> runRepeatedKernelReadsOfPersistentBufferDiagnostic [

	|
		queue
		expectedValues
		kernel
		inputBuffer
		trialCount
		failureCount
	|

	queue := self clQueue.
	expectedValues := #( 1.0 2.0 3.0 4.0 5.0 6.0 7.0 8.0 ).
	kernel := self identityKernel.
	inputBuffer := self clContext newCLBufferWithFloats: expectedValues.
	trialCount := 300.
	failureCount := 0.

	trialCount timesRepeat:
	[
		|
			outputBuffer
			kernelEvent
		|

		outputBuffer := self clContext newCLBufferForSize: 8 * TFBasicType float byteSize.
		kernelEvent :=
			queue
				enqueueKernel:	kernel
				forNDRange:				{ { 8 } }
				withArguments:			{ inputBuffer. outputBuffer }.
		kernelEvent wait.
		kernelEvent release.

		( ( queue readFloatsFrom: outputBuffer count: 8 ) = expectedValues )
			ifFalse: [ failureCount := failureCount + 1 ].

		outputBuffer release.
	].

	self
		assert:	failureCount = 0
		description:
			'repeated-kernel-read-of-persistent-buffer failed ', failureCount printString,
			'/', trialCount printString,
			' times -- see note/pharo-ops.md 34節'.

	inputBuffer release.
	kernel release.
	queue release.
]

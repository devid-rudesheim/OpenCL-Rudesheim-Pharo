"
An EventOpenCLRudesheimTest is a test class for testing the behavior of EventOpenCLRudesheim
"
Class {
	#name : 'EventOpenCLRudesheimTest',
	#superclass : 'BasicOpenCLRudesheimTest',
	#category : 'Rudesheim-OpenCL-Private-Tests-Objects',
	#package : 'Rudesheim-OpenCL-Private-Tests',
	#tag : 'Objects'
}

{ #category : 'accessing' }
EventOpenCLRudesheimTest class >> targetClass [

	^ EventOpenCLRudesheim.
]

{ #category : 'tests' }
EventOpenCLRudesheimTest >> testBasicInstanceCreation [

	self skip: 'Event handles are returned by native OpenCL calls; #new is intentionally unavailable.'.
]

{ #category : 'tests' }
EventOpenCLRudesheimTest >> testBasicInstanceCreation0 [

	self skip: 'Event handles are returned by native OpenCL calls; #new is intentionally unavailable.'.
]

{ #category : 'tests' }
EventOpenCLRudesheimTest >> runWait0 [
	|
		cl
		devices
		context
		program
		queue
		outputBuffer
		kernel
		slowEvent
		otherContext
		otherQueue
	|

	cl := Rudesheim OpenCL.
	devices := cl Platform clPlatforms first clDevices.
	context := self trackForRelease: (cl Context clContextFor: devices).

	program :=
		self
			trackForRelease:
			(
				context
					buildCLProgramFor:	devices
					fromSources:
					{
						'
kernel void SlowLoopRudesheim( global unsigned int *output, unsigned int iterationCount )
{
	unsigned int state;
	unsigned int index;

	state = 1u;
	for( index = 0; index < iterationCount; index++ )
	{
		state = ( state * 1103515245u ) + 12345u;
	}

	output[ 0 ] = state;
}
						'
					}
					withOptions:	self defaultCLStdOption
			).

	queue :=
		self
			trackForRelease:
			(
				cl CommandQueue
					clCommandQueueFor:	devices first
					of:					context
			).

	outputBuffer :=
		self
			trackForRelease:
			(
				context
					newCLBufferForSize:	TFBasicType uint byteSize
			).

	kernel :=
		self
			trackForRelease:
			(
				program
					newCLKernelAt:	'SlowLoopRudesheim'
					withParameterTypes:
					{
						TFBasicType pointer.
						TFBasicType uint.
					}
			).

	slowEvent :=
		self
			trackForRelease:
			(
				queue
					enqueueKernel:	kernel
					forNDRange:
					{
						{ 16r1. 16r1. 16r1. }
					}
					withArguments:
					{
						outputBuffer.
						16r5F5E100.
					}
					forWait:
					{
					}
			).

	[
		slowEvent wait.
	]
		fork.

	( Delay forMilliseconds: 16r0C8 ) wait.

	otherContext :=
		self trackForRelease: (cl Context clContextFor: devices).

	otherQueue :=
		self
			trackForRelease:
			(
				cl CommandQueue
					clCommandQueueFor:	devices first
					of:					otherContext
			).

	otherQueue finish.

]

{ #category : 'tests' }
EventOpenCLRudesheimTest >> testWait [

	self
		testWait0_0.
]

{ #category : 'tests' }
EventOpenCLRudesheimTest >> testWait0_0 [

	self
		timeLimit: 5 seconds;
		runWait0.

]

"
A BufferOpenCLRudesheimTest is a test class for testing the behavior of BufferOpenCLRudesheim, in particular the eager/idempotent native release added to fix the OpenCL native buffer leak (see note/resnet50-onnx-support-plan.md).
"
Class {
	#name : 'BufferOpenCLRudesheimTest',
	#superclass : 'BasicRudesheimTest',
	#instVars : [
		'clContext'
	],
	#category : 'Rudesheim-OpenCL-Private-Tests-Objects',
	#package : 'Rudesheim-OpenCL-Private-Tests',
	#tag : 'Objects'
}

{ #category : 'accessing' }
BufferOpenCLRudesheimTest class >> targetClass [

	^ BufferOpenCLRudesheim.
]

{ #category : 'accessing' }
BufferOpenCLRudesheimTest >> clContext [

	^ clContext
		ifNil:
		[
			clContext :=
				ContextOpenCLRudesheim
					clContextFor:	Rudesheim OpenCL Platform clPlatforms first clDevices.
		].

]

{ #category : 'accessing' }
BufferOpenCLRudesheimTest >> clQueue [

	^ self clContext
		newCLCommandQueueFor:	Rudesheim OpenCL Platform clPlatforms first clDevices first.
]

{ #category : 'accessing' }
BufferOpenCLRudesheimTest >> defaultBasicTarget [

	^ self clContext
		newCLBufferForSize:	16r10
		options:
		{
			Rudesheim OpenCL ReadWrite.
		}.
]

{ #category : 'tests' }
BufferOpenCLRudesheimTest >> testReleaseClearsHandlePointer [

	self
		deny:	self basicTarget handlePointer isNil.

	self basicTarget release.

	self
		assert:	self basicTarget handlePointer isNil.
]

{ #category : 'tests' }
BufferOpenCLRudesheimTest >> testReleaseIsIdempotent [

	self basicTarget release.

	self
		shouldnt:	[ self basicTarget release ]
		raise:		Error.
]

{ #category : 'tests' }
BufferOpenCLRudesheimTest >> testReleaseRemovesFromFinalizationRegistry [

	self
		assert:	( FFIExternalResourceManager uniqueInstance includes: self basicTarget ).

	self basicTarget release.

	self
		deny:	( FFIExternalResourceManager uniqueInstance includes: self basicTarget ).
]

{ #category : 'tests' }
BufferOpenCLRudesheimTest >> testAsOpenCLBufferRudesheimIsSameContextNoOp [
	"See note/opencl-layer-buffer-passthrough-design.md: a buffer already on
	the (only) context is returned unchanged, not re-uploaded."

	self
		assert:	( self basicTarget asOpenCLBufferRudesheim: self clContext )
		identicalTo:	self basicTarget.
]

{ #category : 'tests' }
BufferOpenCLRudesheimTest >> testAsArrayRoundTripsThroughUpload [
	|
		uploaded
		queue
	|

	queue := self clQueue.
	uploaded := self clContext newCLBufferWithFloats: #( 1.0 -2.0 3.5 ).
	uploaded
		count:	3;
		queue:	queue.

	self
		assert:	uploaded asArray
		equals:	#( 1.0 -2.0 3.5 ).

	uploaded release.
	queue release.
]

{ #category : 'tests' }
BufferOpenCLRudesheimTest >> testSequenceableCollectionAsOpenCLBufferRudesheimUploadsAndTagsCount [
	|
		uploaded
	|

	uploaded := #( 1.0 2.0 3.0 4.0 ) asOpenCLBufferRudesheim: self clContext.

	self assert: uploaded count equals: 4.
	self assert: (uploaded isKindOf: BufferOpenCLRudesheim).

	uploaded release.
]

{ #category : 'tests' }
BufferOpenCLRudesheimTest >> testRudesheimConcatenatedWithMergesTwoBuffersOnGPUWithoutReleasingEither [
	"See note/opencl-layer-buffer-passthrough-design.md, 'AddLayerの分岐合流':
	merging two live buffers must not require downloading either to the host."
	|
		queue
		bufferA
		bufferB
		combined
	|

	queue := self clQueue.
	bufferA := self clContext newCLBufferWithFloats: #( 1.0 2.0 ).
	bufferA
		count:		2;
		queue:		queue;
		context:	self clContext.
	bufferB := self clContext newCLBufferWithFloats: #( 3.0 4.0 5.0 ).
	bufferB
		count:		3;
		queue:		queue;
		context:	self clContext.

	combined := bufferA rudesheimConcatenatedWith: bufferB.

	self assert: combined asArray equals: #( 1.0 2.0 3.0 4.0 5.0 ).
	self deny: bufferA handlePointer isNil.
	self deny: bufferB handlePointer isNil.

	bufferA release.
	bufferB release.
	combined release.
	queue release.
]

{ #category : 'tests' }
BufferOpenCLRudesheimTest >> testRudesheimConcatenatedWithUploadsAndReleasesPlainArrayArgument [
	|
		queue
		bufferA
		combined
	|

	queue := self clQueue.
	bufferA := self clContext newCLBufferWithFloats: #( 1.0 2.0 ).
	bufferA
		count:		2;
		queue:		queue;
		context:	self clContext.

	combined := bufferA rudesheimConcatenatedWith: #( 3.0 4.0 5.0 ).

	self assert: combined asArray equals: #( 1.0 2.0 3.0 4.0 5.0 ).

	bufferA release.
	combined release.
	queue release.
]

{ #category : 'tests' }
BufferOpenCLRudesheimTest >> testSequenceableCollectionRudesheimConcatenatedWithDownloadsBufferArgument [
	|
		queue
		bufferB
		result
	|

	queue := self clQueue.
	bufferB := self clContext newCLBufferWithFloats: #( 3.0 4.0 ).
	bufferB
		count:	2;
		queue:	queue.

	result := #( 1.0 2.0 ) rudesheimConcatenatedWith: bufferB.

	self assert: result equals: #( 1.0 2.0 3.0 4.0 ).

	bufferB release.
	queue release.
]

{ #category : 'tests' }
BufferOpenCLRudesheimTest >> testReleaseRudesheimIsPolymorphicOverArrayAndBuffer [
	"See note/opencl-layer-buffer-passthrough-design.md: code that may be
	holding either a plain Array or a BufferOpenCLRudesheim can call
	releaseRudesheim on either without a kind check."

	self shouldnt: [ #( 1.0 2.0 ) releaseRudesheim ] raise: Error.

	self
		deny:	self basicTarget handlePointer isNil.
	self basicTarget releaseRudesheim.
	self
		assert:	self basicTarget handlePointer isNil.
]

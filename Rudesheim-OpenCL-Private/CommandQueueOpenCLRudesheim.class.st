Class {
	#name : 'CommandQueueOpenCLRudesheim',
	#superclass : 'HandleNativeOpenCLRudesheim',
	#instVars : [
		'tfRunner'
	],
	#classInstVars : [
		'nextTFWorkerNameSequence'
	],
	#category : 'Rudesheim-OpenCL-Private-Objects',
	#package : 'Rudesheim-OpenCL-Private',
	#tag : 'Objects'
}

{ #category : 'instance creation' }
CommandQueueOpenCLRudesheim class >> clCommandQueueFor:		aCLDevice
of: 					aCLContext [

	^
	[
		super
			newWithArguments:
			{
				aCLContext handlePointer.
				aCLDevice idPointer.
				ExternalAddress null.
			}
	]
		on: PrimitiveErrorNativeOpenCLRudesheim
		do:
		[ :anError |
			Rudesheim OpenCL Native Error CommandQueueCreationFailed
				signalForCause:	anError
				device:				aCLDevice
				context:			aCLContext.
		].

]

{ #category : 'accessing' }
CommandQueueOpenCLRudesheim class >> functionsOfCreationAndRelease [

	^ Rudesheim OpenCL Native Functions functionsOfCommandQueue.
]

{ #category : 'instance creation' }
CommandQueueOpenCLRudesheim class >> newWithArguments:	aArgumentsSequencialCollection [
	
	^ self shouldNotImplement.
]

{ #category : 'accessing' }
CommandQueueOpenCLRudesheim class >> nextTFWorkerName [

	nextTFWorkerNameSequence :=
		( nextTFWorkerNameSequence ifNil: [ 0 ] ) + 1.

	^ 'OpenCL-CommandQueue-', nextTFWorkerNameSequence printString.

]

{ #category : 'accessing' }
CommandQueueOpenCLRudesheim >> enqueueCopyFrom:	anInputCLBuffer
offset:				anOffset
to:					anOutputCLBuffer
forRange:			aRangeInterval
as:					aTFType [

	^ self
		enqueueCopyFrom:	anInputCLBuffer
		offset:				anOffset
		to:					anOutputCLBuffer
		forRange:			aRangeInterval
		as:					aTFType
		forWait:			Array empty.

]

{ #category : 'accessing' }
CommandQueueOpenCLRudesheim >> enqueueCopyFrom:	anInputCLBuffer
offset:				anOffset
to:					anOutputCLBuffer
forRange:			aRangeInterval
as:					aTFType
forWait:			anEventForWaitCollection [
	|
		cl
		functions
		scalerSize
	|

	cl := Rudesheim OpenCL.
	functions := cl Native Functions.

	scalerSize := aTFType byteSize.

	^
	[
		cl Event
			newFromFunctionForEnqueue:	functions functionOfEnqueueCopyBuffer
			withArguments:
			{
				anInputCLBuffer handlePointer.
				anOutputCLBuffer handlePointer.
				scalerSize * anOffset.
				scalerSize * ( aRangeInterval first - 1 ).
				scalerSize * aRangeInterval size.
			}
			forWait:						anEventForWaitCollection
			on:								self
			by:								self tfRunner.
	]
		on: PrimitiveErrorNativeOpenCLRudesheim
		do:
		[ :anError |
			Rudesheim OpenCL Native Error EnqueueCopyFailed
				signalForCause:	anError
				commandQueue:	self
				inputBuffer:		anInputCLBuffer
				outputBuffer:		anOutputCLBuffer
				offset:				anOffset
				range:				aRangeInterval.
		].


]

{ #category : 'accessing' }
CommandQueueOpenCLRudesheim >> enqueueFill:	aCLBuffer
byPattern:		aPatternByteArray
forRange: 		anRangeInterval [

	^ self
		enqueueFill:	aCLBuffer
		byPattern:		aPatternByteArray
		forRange:		anRangeInterval
		forWait:		Array empty.
]

{ #category : 'accessing' }
CommandQueueOpenCLRudesheim >> enqueueFill:	aCLBuffer
byPattern:		aPatternByteArray
forRange: 		aRangeInterval
forWait:		anEventForWaitCollection [
	|
		cl
		functions
		scalerSize
	|

	cl := Rudesheim OpenCL.
	functions := cl Native Functions.

	scalerSize := aPatternByteArray byteSize.

	^
	[
		cl Event
			newFromFunctionForEnqueue:	functions functionOfEnqueueFillBuffer
			withArguments:
			{
				aCLBuffer handlePointer.
				aPatternByteArray tfPointerAddress.
				scalerSize.
				scalerSize * ( aRangeInterval first - 1 ).
				scalerSize * aRangeInterval size.
			}
			forWait:						anEventForWaitCollection
			on:								self
			by:								self tfRunner.
	]
		on: PrimitiveErrorNativeOpenCLRudesheim
		do:
		[ :anError |
			Rudesheim OpenCL Native Error EnqueueFillFailed
				signalForCause:	anError
				commandQueue:	self
				buffer:				aCLBuffer
				pattern:			aPatternByteArray
				range:				aRangeInterval.
		].

]

{ #category : 'accessing' }
CommandQueueOpenCLRudesheim >> enqueueKernel: 	aCLKernel
forNDRange:			aNDRange
withArguments: 	aCLBufferSequencialCollections [

	^ self
		enqueueKernel: 	aCLKernel
		forNDRange:			aNDRange
		withArguments: 	aCLBufferSequencialCollections
		forWait:			Array empty.

]

{ #category : 'accessing' }
CommandQueueOpenCLRudesheim >> enqueueKernel: 	aCLKernel
forNDRange:			aNDRange
withArguments: 	aCLBufferSequencialCollections
forWait:			anEventForWaitCollection [
	|
		cl
		functions
		ndRangePointes
		sizeT
	|

	0 >= aNDRange size
		ifTrue:
		[
			^ self.
		].

	cl := Rudesheim OpenCL.
	functions := cl Native Functions.

	sizeT := TFBasicType sizeT.

	aCLBufferSequencialCollections
		withIndexDo:
		[ :each :index |
			aCLKernel
				at:		index
				put:	each
		].

	sizeT := TFBasicType sizeT.

	ndRangePointes :=
	(
		1
			to: 3
	)
		collect:
		[ :each |
			ExternalAddress null.
		].

	(
		aNDRange
			collect:
			[ :each0 |
				|
					sizes
				|

				sizes :=
					ExternalAddress
						gcallocate: 3 * sizeT byteSize.

				each0
					withIndexDo:
					[ :each1 :index |
						sizes
							uint64AtOffset: 	( index - 1 ) * sizeT byteSize
							put:				each1.
					].

				sizes.
			]
	)
		withIndexDo:
		[ :each :index |
			ndRangePointes
				at:		index
				put:	each tfPointerAddress.
		].

	^
	[
		cl Event
			newFromFunctionForEnqueue:	functions functionOfEnqueueNDRangeKernel
			withArguments:
			{
				aCLKernel handlePointer.
				aNDRange first size.
				ndRangePointes
					at: 3.
				ndRangePointes
					at: 1.
				ndRangePointes
					at: 2.
			}
			forWait:						anEventForWaitCollection
			on:								self
			by:								self tfRunner.
	]
		on: PrimitiveErrorNativeOpenCLRudesheim
		do:
		[ :anError |
			Rudesheim OpenCL Native Error EnqueueKernelFailed
				signalForCause:	anError
				commandQueue:	self
				kernel:				aCLKernel
				ndRange:			aNDRange.
		].

]

{ #category : 'accessing' }
CommandQueueOpenCLRudesheim >> enqueueKernelAndWait:	aCLKernel
forNDRange:				aNDRange
withArguments:			aCLBufferSequencialCollections [
	"Every enqueue* method returns a fresh EventOpenCLRudesheim backed by a
	native cl_event that is never released just by waiting on it (see
	EventOpenCLRudesheim>>wait) -- release it here once the wait completes,
	so this widely-used method doesn't leak one native Event handle per
	call. See note/pharo-ops.md 34節 for the corruption this leak was
	causing under repeated forward: calls."
	|
		event
	|

	event :=
		self
			enqueueKernel:		aCLKernel
			forNDRange:			aNDRange
			withArguments:		aCLBufferSequencialCollections
			forWait:			{}.

	event wait.
	event release.
]

{ #category : 'accessing' }
CommandQueueOpenCLRudesheim >> enqueueMap:		aCLBuffer
forRange:		aRangeInterval
as:				aTFType
options: 		anOptions
blocking: 		aBloolean
forWait:		anEventForWaitCollection [
	|
		cl
		functions
		event
		pointer
	|

	cl := Rudesheim OpenCL.
	functions := cl Native Functions.

	pointer := nil.

	event :=
		[
			(
				cl Event
					withCLEventOnDo:
					[ :eventOutput |
						|
							errorOutput
							scalerSize
							sint32
						|

						sint32 := TFBasicType sint32.
						errorOutput :=
							ExternalAddress
								gcallocate: sint32 byteSize.

						sint32
							write: 	0
							into: 	errorOutput.

						scalerSize := aTFType byteSize.

						pointer :=
							self tfRunner
								invokeFunction:	functions functionsOfEnqueueMap first
								withArguments:
								{
									self handlePointer.
									aCLBuffer handlePointer.
									aBloolean asInteger.
									anOptions
										inject:	0
										into:
										[ :value :each |
											value | each clMapType
										].
									scalerSize * ( aRangeInterval first - 1 ).
									scalerSize * aRangeInterval size.
									anEventForWaitCollection size.
									cl Event
										convertToNativeArray:	anEventForWaitCollection.
									eventOutput.
									errorOutput.
								}.

							sint32
								readValue: errorOutput
					]
			)
				tfRunnerOwner:	self;
				yourself.
		]
			on: PrimitiveErrorNativeOpenCLRudesheim
			do:
			[ :anError |
				Rudesheim OpenCL Native Error EnqueueMapFailed
					signalForCause:	anError
					commandQueue:	self
					buffer:				aCLBuffer
					range:				aRangeInterval
					options:			anOptions
					blocking:			aBloolean.
			].

	^
	{
		pointer.
		event.
	}.


]

{ #category : 'accessing' }
CommandQueueOpenCLRudesheim >> enqueueMap:		aCLBuffer
forRange:		aRangeInterval
as:				aTFType
options: 		anOptions
blocking: 		aBloolean
forWait:		anEventForWaitCollection
do:				aBlock [
	"tupe last (the map Event) is only ever used as an unmap dependency below
	-- release it once the unmap has been enqueued, so callers only need to
	deal with the returned unmap Event. See enqueueKernelAndWait:forNDRange:
	withArguments: for why leaving an Event unreleased matters here."
	|
		tupe
		unmapEvent
	|

	tupe :=
		self
			enqueueMap:		aCLBuffer
			forRange:		aRangeInterval
			as:				aTFType
			options: 		anOptions
			blocking: 		aBloolean
			forWait:		anEventForWaitCollection.
	[

		aBlock
			value:	tupe first.

	]
		ensure:
		[
			unmapEvent :=
				self
					enqueueUnmap:	tupe first
					of: 			aCLBuffer
					forWait:
					{
						tupe last
					}.
			tupe last release.
		].

	^ unmapEvent
]

{ #category : 'accessing' }
CommandQueueOpenCLRudesheim >> enqueueUnmap: 	anExternalObject
of: 			aCLBuffer
forWait:		anEventForWaitCollection [
	|
		cl
		functions
	|

	cl := Rudesheim OpenCL.
	functions := cl Native Functions.

	^
	[
		cl Event
			newFromFunctionForEnqueue:	functions functionsOfEnqueueMap last
			withArguments:
			{
				aCLBuffer handlePointer.
				anExternalObject.
			}
			forWait:						anEventForWaitCollection
			on:								self
			by:								self tfRunner.
	]
		on: PrimitiveErrorNativeOpenCLRudesheim
		do:
		[ :anError |
			Rudesheim OpenCL Native Error EnqueueUnmapFailed
				signalForCause:	anError
				commandQueue:	self
				buffer:				aCLBuffer.
		].


]

{ #category : 'flushing' }
CommandQueueOpenCLRudesheim >> finish [
	|
		native
		functions
	|

	native := Rudesheim OpenCL Native.
	functions := native Functions.

	[
		native Error Primitive
			shouldZero:
			[
				self tfRunner
					invokeFunction:	functions functionOfFinish
					withArguments:
					{
						self handlePointer
					}.
			].
	]
		on: PrimitiveErrorNativeOpenCLRudesheim
		do:
		[ :anError |
			Rudesheim OpenCL Native Error CommandQueueFinishFailed
				signalForCause:	anError
				commandQueue:	self.
		].

]

{ #category : 'flushing' }
CommandQueueOpenCLRudesheim >> flush [
	|
		native
		functions
	|

	native := Rudesheim OpenCL Native.
	functions := native Functions.

	[
		native Error Primitive
			shouldZero:
			[
				self tfRunner
					invokeFunction:	functions functionOfFlush
					withArguments:
					{
						self handlePointer
					}.
			].
	]
		on: PrimitiveErrorNativeOpenCLRudesheim
		do:
		[ :anError |
			Rudesheim OpenCL Native Error CommandQueueFlushFailed
				signalForCause:	anError
				commandQueue:	self.
		].

]

{ #category : 'accessing' }
CommandQueueOpenCLRudesheim >> readFrom:	aCLBuffer
count:	aCountInteger
elementType:	aTFBasicType [
	"enqueueMap:...do: returns the unmap Event (its own map Event is already
	released internally). Waiting on it without releasing it afterward would
	leak one native cl_event per download -- across a resnet50 forward:
	pass's many downloads (and every repeated forward: call on the same
	model), this leak was confirmed to eventually corrupt unrelated buffer
	content (see note/pharo-ops.md 34節)."
	|
		cl
		elementTypeClass
		result
		unmapEvent
	|

	cl := Rudesheim OpenCL.
	elementTypeClass := aTFBasicType openCLElementTypeRudesheim.
	result := nil.

	unmapEvent :=
		self
			enqueueMap:		aCLBuffer
			forRange:		( 1 to: aCountInteger )
			as:				aTFBasicType
			options:		{ cl ReadOnly }
			blocking:		true
			forWait:		{}
			do:
			[ :rawPointer |
				result :=
					elementTypeClass
						readElementsFrom:	rawPointer
						count:	aCountInteger.
			].

	unmapEvent wait.
	unmapEvent release.

	^ result.
]

{ #category : 'finalization' }
CommandQueueOpenCLRudesheim >> resourceData [

	^
	{
		handlePointer.
		self tfRunner.
	}.

]

{ #category : 'accessing' }
CommandQueueOpenCLRudesheim >> tfRunner [

	^ tfRunner
		ifNil:
		[
			tfRunner :=
				TFWorker
					named:	self class nextTFWorkerName.
		].

]

Class {
	#name : 'EventOpenCLRudesheim',
	#superclass : 'HandleNativeOpenCLRudesheim',
	#instVars : [
		'tfRunnerOwner'
	],
	#category : 'Rudesheim-OpenCL-Private-Objects',
	#package : 'Rudesheim-OpenCL-Private',
	#tag : 'Objects'
}

{ #category : 'instance creation' }
EventOpenCLRudesheim class >> clEventOf:	aCLContext [

	^
	[
		(
			super
				newWithArguments:
				{
					aCLContext handlePointer.
				}
		)
			tfRunnerOwner:	aCLContext;
			yourself.
	]
		on: PrimitiveErrorNativeOpenCLRudesheim
		do:
		[ :anError |
			Rudesheim OpenCL Native Error EventCreationFailed
				signalForCause:	anError
				context:			aCLContext.
		].

]

{ #category : 'converting' }
EventOpenCLRudesheim class >> convertToNativeArray:	anCLEventSequencialCollection [ 
	|
		native
		functions
		pointer
		nativeEvents
	|

	native := Rudesheim OpenCL Native.
	functions := native Functions.

	pointer := TFBasicType pointer.

	nativeEvents :=
		ExternalAddress
			gcallocate: pointer byteSize * anCLEventSequencialCollection size.

	anCLEventSequencialCollection
		withIndexDo:
		[ :each :index |

			nativeEvents
				pointerAtOffset: 	( index - 1 ) * pointer byteSize
				put: 				each handlePointer tfPointerAddress.

		].
	
	anCLEventSequencialCollection
		ifEmpty:
		[
			nativeEvents := ExternalAddress null.
		].

	^ nativeEvents.
]

{ #category : 'accessing' }
EventOpenCLRudesheim class >> functionsOfCreationAndRelease [

	^ Rudesheim OpenCL Native Functions functionsOfEvent.
]

{ #category : 'instance creation' }
EventOpenCLRudesheim class >> newFromFunctionForEnqueue:	anEnqueueTFFunction
withArguments:					anArgumentsSequencialCollection
forWait:						anCLEventForWaitCollection
on:								aCLCommandQueue
by:								aTFRunner [
	|
		native
		functions
	|

	native := Rudesheim OpenCL Native.
	functions := native Functions.

	^
	(
		self
			withCLEventOnDo:
			[ :eventOutput |

				aTFRunner
					invokeFunction:	anEnqueueTFFunction
					withArguments:
					(
						{
							aCLCommandQueue handlePointer
						},
						anArgumentsSequencialCollection,
						{
							anCLEventForWaitCollection size.
							self
								convertToNativeArray:	anCLEventForWaitCollection.
							eventOutput.
						}
					).

			]
	)
		tfRunnerOwner:	aCLCommandQueue;
		yourself.

]

{ #category : 'waiting' }
EventOpenCLRudesheim class >> waitForCLEvents:	aCLEventCollection [
	|
		cl
		functions
		events
		pointer
		uint32
		runner
	|

	cl := Rudesheim OpenCL.
	functions := cl Native Functions.

	pointer := TFBasicType pointer.
	uint32 := TFBasicType uint32.

	runner :=
		aCLEventCollection
			ifEmpty:	[ functions tfRunner ]
			ifNotEmpty:	[ aCLEventCollection first tfRunner ].

	events :=
		ExternalAddress
			gcallocate: pointer byteSize * aCLEventCollection size.

	aCLEventCollection
		withIndexDo:
		[ :each :index |
			events
				pointerAtOffset: 	( index - 1 ) * pointer byteSize
				put: 				each handlePointer tfPointerAddress.
		].

	[
		cl Native Error Primitive
			shouldZero:
			[
				runner
					invokeFunction:	functions functionOfWaitForEvents
					withArguments:
					{
						aCLEventCollection size.
						events.
					}.
			].
	]
		on: PrimitiveErrorNativeOpenCLRudesheim
		do:
		[ :anError |
			Rudesheim OpenCL Native Error EventWaitFailed
				signalForCause:	anError
				events:			aCLEventCollection.
		].

]

{ #category : 'instance creation' }
EventOpenCLRudesheim class >> withCLEventOnDo:	aBlock [
	|
		eventOutput
		pointer
	|

	pointer := TFBasicType pointer.
	eventOutput :=
		ExternalAddress
			gcallocate: pointer byteSize.
	
	pointer
		write: 	0
		into: 	eventOutput.

	Rudesheim OpenCL Native Error Primitive
		shouldZero:
		[			
			aBlock
				value:	eventOutput.
		].

	^ super basicNew
		setHandle:
		(
			pointer
				readValue: eventOutput
		);
		yourself.
]

{ #category : 'accessing' }
EventOpenCLRudesheim >> status: anInterger [
	|
		cl
		functions
	|

	cl := Rudesheim OpenCL.
	functions := cl Native Functions.

	[
		cl Native Error Primitive
			shouldZero:
			[
				self tfRunner
					invokeFunction:	functions functionOfSetUserEventStatus
					withArguments:
					{
						self handlePointer.
						anInterger.
					}.
			].
	]
		on: PrimitiveErrorNativeOpenCLRudesheim
		do:
		[ :anError |
			Rudesheim OpenCL Native Error EventStatusChangeFailed
				signalForCause:	anError
				event:				self
				status:			anInterger.
		].

]

{ #category : 'accessing' }
EventOpenCLRudesheim >> tfRunner [

	^ self tfRunnerOwner tfRunner.

]

{ #category : 'accessing' }
EventOpenCLRudesheim >> tfRunnerOwner [

	^ tfRunnerOwner
		ifNil:
		[
			tfRunnerOwner := Rudesheim OpenCL Native Functions.
		].

]

{ #category : 'accessing' }
EventOpenCLRudesheim >> tfRunnerOwner: anObject [

	tfRunnerOwner := anObject.

]

{ #category : 'waiting' }
EventOpenCLRudesheim >> wait [

	self class
		waitForCLEvents:
		{
			self
		}.
]

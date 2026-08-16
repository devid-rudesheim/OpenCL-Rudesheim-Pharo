Class {
	#name : 'ContextOpenCLRudesheim',
	#superclass : 'HandleNativeOpenCLRudesheim',
	#instVars : [
		'tfRunner',
		'programCache',
		'kernelCache'
	],
	#classInstVars : [
		'nextTFWorkerNameSequence'
	],
	#category : 'Rudesheim-OpenCL-Private-Objects',
	#package : 'Rudesheim-OpenCL-Private',
	#tag : 'Objects'
}

{ #category : 'instance creation' }
ContextOpenCLRudesheim class >> clContextFor:	aCLDevices [
	|
		deviceIDs
		pointer
		uint32
	|

	pointer := TFBasicType pointer.
	uint32 := TFBasicType uint32.

	deviceIDs :=
		ExternalAddress
			gcallocate: pointer byteSize * aCLDevices size.

	aCLDevices
		withIndexDo:
		[ :each :index |
			deviceIDs
				pointerAtOffset: 	( index - 1 ) * pointer byteSize
				put: 				each idPointer tfPointerAddress.
		].

	^
	[
		super
			newWithArguments:
			{
				ExternalAddress null.
				aCLDevices size.
				deviceIDs.
				ExternalAddress null.
				ExternalAddress null.
			}
	]
		on: PrimitiveErrorNativeOpenCLRudesheim
		do:
		[ :anError |
			Rudesheim OpenCL Native Error ContextCreationFailed
				signalForCause:	anError
				devices:			aCLDevices.
		].

]

{ #category : 'accessing' }
ContextOpenCLRudesheim class >> functionsOfCreationAndRelease [

	^ Rudesheim OpenCL Native Functions functionsOfContext.
]

{ #category : 'instance creation' }
ContextOpenCLRudesheim class >> newWithArguments:	aArgumentsSequencialCollection [
	
	^ self shouldNotImplement.
]

{ #category : 'accessing' }
ContextOpenCLRudesheim class >> nextTFWorkerName [

	nextTFWorkerNameSequence :=
		( nextTFWorkerNameSequence ifNil: [ 0 ] ) + 1.

	^ 'OpenCL-Context-', nextTFWorkerNameSequence printString.

]

{ #category : 'instance creation' }
ContextOpenCLRudesheim >> buildCLProgramFor:	aCLDevicesCollection
fromSources:		aStringCollection
withOptions:		anOptionsString [

	^ Rudesheim OpenCL Program
		buildCLProgramFor:	aCLDevicesCollection
		fromSources:		aStringCollection
		withOptions:		anOptionsString
		of:					self.
]

{ #category : 'instance creation' }
ContextOpenCLRudesheim >> cachedCLKernelAt:	aNameString
ofProgram:			aCLProgram
withParameterTypes:	aCTypeSequencialCollection [

	^ self kernelCache
		at:			{ aCLProgram. aNameString. aCTypeSequencialCollection }
		ifAbsentPut:
		[
			aCLProgram
				newCLKernelAt:			aNameString
				withParameterTypes:	aCTypeSequencialCollection.
		].
]

{ #category : 'instance creation' }
ContextOpenCLRudesheim >> cachedCLProgramFor:	aCLDevicesCollection
fromSources:		aStringCollection
withOptions:		anOptionsString [

	^ self programCache
		at:			{ aCLDevicesCollection. aStringCollection. anOptionsString }
		ifAbsentPut:
		[
			self
				buildCLProgramFor:	aCLDevicesCollection
				fromSources:		aStringCollection
				withOptions:		anOptionsString.
		].
]

{ #category : 'instance creation' }
ContextOpenCLRudesheim >> compileCLProgramFor:	aCLDevicesCollection
fromSources:		aStringCollection
withOptions:		anOptionsString
headers:			aHeaderAssociationsCollection [

	^ Rudesheim OpenCL Program
		compileCLProgramFor:	aCLDevicesCollection
		fromSources:		aStringCollection
		withOptions:		anOptionsString
		headers:			aHeaderAssociationsCollection
		of:					self.
]

{ #category : 'accessing' }
ContextOpenCLRudesheim >> kernelCache [
	^ kernelCache ifNil: [ kernelCache := Dictionary new ].
]

{ #category : 'instance creation' }
ContextOpenCLRudesheim >> newCLBufferForElementCount:	anElementCountInteger
elementType:	aTFBasicType [

	^ self
		newCLBufferForSize:	anElementCountInteger * aTFBasicType openCLElementTypeRudesheim byteSize
]

{ #category : 'instance creation' }
ContextOpenCLRudesheim >> newCLBufferForElementCount:	anElementCountInteger
elementType:	aTFBasicType
options:	aCLTBufferDefineCollection [

	^ self
		newCLBufferForSize:	anElementCountInteger * aTFBasicType openCLElementTypeRudesheim byteSize
		options:			aCLTBufferDefineCollection
]

{ #category : 'instance creation' }
ContextOpenCLRudesheim >> newCLBufferForSize: 	aSizeInteger [
	|
		cl
	|

	cl := Rudesheim OpenCL.

	^ cl Buffer
		clBufferForSize:	aSizeInteger
		options:
		{
			cl ReadWrite
		}
		of:					self.
]

{ #category : 'instance creation' }
ContextOpenCLRudesheim >> newCLBufferForSize: 	aSizeInteger
options:				aCLTBufferDefineCollection [

	^ Rudesheim OpenCL Buffer
		clBufferForSize:	aSizeInteger
		options:			aCLTBufferDefineCollection
		of:					self.
]

{ #category : 'instance creation' }
ContextOpenCLRudesheim >> newCLBufferWith:	aByteArray [
	|
		cl
	|

	cl := Rudesheim OpenCL.

	^ cl Buffer
		clBufferWith:	aByteArray
		options:
		{
			cl ReadWrite.
			cl HostPtr Use.
		}
		of:				self.
]

{ #category : 'instance creation' }
ContextOpenCLRudesheim >> newCLBufferWith:	aCollection
elementType:	aTFBasicType [
	"See the comment on newCLBufferWith:elementType:options: -- CL_MEM_USE_HOST_PTR is safe here
	only because the host pointer comes from a permanently-pinned ByteArray, not from
	ExternalAddress class>>gcallocate: -- see note/pharo-ops.md 34節."

	^ self
		newCLBufferWith:	aCollection
		elementType:		aTFBasicType
		options:
		{
			Rudesheim OpenCL ReadWrite.
			Rudesheim OpenCL HostPtr Use.
		}.
]

{ #category : 'instance creation' }
ContextOpenCLRudesheim >> newCLBufferWith:	aCollection
elementType:	aTFBasicType
options:	aCLTBufferDefineCollection [
	"Builds the host-side ByteArray via #tfPointerAddress (BufferOpenCLRudesheim class>>
	clBufferWith:options:of:), which permanently pins it (Object>>pinInMemory, never unpinned),
	rather than handing the driver a raw pointer backed by ExternalAddress class>>gcallocate:.

	That prior approach was a confirmed use-after-free: gcallocate:'s backing memory is freed as
	soon as its ExternalAddress wrapper is garbage collected, and the local `pointer` temp was
	never retained by anything past this method returning. Switching the CL_MEM_* flag alone
	(Use -> Copy) measured no improvement (~50% corruption either way on a persistent buffer read
	by many kernel launches, see note/pharo-ops.md 34節 for the reproduction) -- Apple's cl2Metal
	COPY_HOST_PTR does not appear to fully detach from the supplied pointer at creation time the
	way the OpenCL spec implies it should. A permanently-pinned Smalltalk ByteArray, verified via
	the same reproduction (0/300 failures), is what actually fixes it."
	|
		byteArray
		elementTypeClass
	|

	elementTypeClass := aTFBasicType openCLElementTypeRudesheim.
	byteArray :=
		ByteArray
			new:	aCollection size * elementTypeClass byteSize.

	elementTypeClass
		writeElementsOf:	aCollection
		intoByteArray:		byteArray.

	^ Rudesheim OpenCL Buffer
		clBufferWith:	byteArray
		options:		aCLTBufferDefineCollection
		of:				self.
]

{ #category : 'instance creation' }
ContextOpenCLRudesheim >> newCLBufferWith:	aByteArray
options:			aCLTBufferDefineCollection [

	^ Rudesheim OpenCL Buffer
		clBufferWith:	aByteArray
		options:		aCLTBufferDefineCollection
		of:				self.
]

{ #category : 'instance creation' }
ContextOpenCLRudesheim >> newCLCommandQueueFor: aCLDevice [

	^ Rudesheim OpenCL CommandQueue
		clCommandQueueFor: aCLDevice
		of: 				self.
]

{ #category : 'instance creation' }
ContextOpenCLRudesheim >> newCLEvent [

	^ Rudesheim OpenCL Event
		clEventOf:	self.
]

{ #category : 'instance creation' }
ContextOpenCLRudesheim >> newCLProgramByLinking:	aProgramsCollection
for:					aCLDevicesCollection
withOptions:			anOptionsString [

	^ Rudesheim OpenCL Program
		clProgramByLinking:	aProgramsCollection
		for:					aCLDevicesCollection
		withOptions:			anOptionsString
		of:						self.
]

{ #category : 'accessing' }
ContextOpenCLRudesheim >> programCache [
	^ programCache ifNil: [ programCache := Dictionary new ].
]

{ #category : 'finalization' }
ContextOpenCLRudesheim >> resourceData [

	^
	{
		handlePointer.
		self tfRunner.
	}.

]

{ #category : 'accessing' }
ContextOpenCLRudesheim >> tfRunner [

	^ tfRunner
		ifNil:
		[
			tfRunner :=
				TFWorker
					named:	self class nextTFWorkerName.
		].

]

Class {
	#name : 'BufferOpenCLRudesheim',
	#superclass : 'HandleNativeOpenCLRudesheim',
	#instVars : [
		'count',
		'queue',
		'context',
		'hostByteArray'
	],
	#category : 'Rudesheim-OpenCL-Private-Objects',
	#package : 'Rudesheim-OpenCL-Private',
	#tag : 'Objects'
}

{ #category : 'instance creation' }
BufferOpenCLRudesheim class >> clBufferForSize:	aSizeInteger
hostPointer:		aHostPointerExternalAddress
options:			aCLTBufferDefineCollection
of:					aCLContext [

	^
	[
		super
			newWithArguments:
			{
				aCLContext handlePointer.
				aCLTBufferDefineCollection
					inject:	0
					into:
					[ :value :each |
						value | each clBufferType
					].
				aSizeInteger.
				aHostPointerExternalAddress.
			}
	]
		on: PrimitiveErrorNativeOpenCLRudesheim
		do:
		[ :anError |
			Rudesheim OpenCL Native Error BufferCreationFailed
				signalForCause:	anError
				context:			aCLContext
				options:			aCLTBufferDefineCollection
				sizeInBytes:		aSizeInteger.
		].
]

{ #category : 'instance creation' }
BufferOpenCLRudesheim class >> clBufferForSize:	aSizeInteger
options:			aCLTBufferDefineCollection
of:					aCLContext [

	^
	[
		super
			newWithArguments:
			{
				aCLContext handlePointer.
				aCLTBufferDefineCollection
					inject:	0
					into:
					[ :value :each |
						value | each clBufferType
					].
				aSizeInteger.
				ExternalAddress null.
			}
	]
		on: PrimitiveErrorNativeOpenCLRudesheim
		do:
		[ :anError |
			Rudesheim OpenCL Native Error BufferCreationFailed
				signalForCause:	anError
				context:			aCLContext
				options:			aCLTBufferDefineCollection
				sizeInBytes:		aSizeInteger.
		].

]

{ #category : 'instance creation' }
BufferOpenCLRudesheim class >> clBufferWith:	aByteArray
options:		aCLTBufferDefineCollection
of:				aCLContext [
	"aByteArray tfPointerAddress pins it (permanently -- see Object>>pinInMemory) so the driver's
	raw pointer into it stays valid across GC compaction, but pinning alone does not keep the
	ByteArray reachable: an unreferenced pinned object is still ordinary garbage and its memory is
	still reclaimed. hostByteArray: below stores the reference on the returned buffer itself, so
	aByteArray stays alive for exactly as long as the OpenCL buffer using it does -- this was a
	confirmed use-after-free without it (a buffer created with CL_MEM_USE_HOST_PTR and no retained
	Smalltalk reference to its host memory corrupted at the same ~50% rate whether that memory came
	from ExternalAddress class>>gcallocate: or from an otherwise-unreferenced pinned ByteArray; see
	note/pharo-ops.md 34節 for both reproductions)."

	^
	(
		[
			super
				newWithArguments:
				{
					aCLContext handlePointer.
					aCLTBufferDefineCollection
						inject:	0
						into:
						[ :value :each |
							value | each clBufferType
						].
					aByteArray byteSize.
					aByteArray tfPointerAddress.
				}
		]
			on: PrimitiveErrorNativeOpenCLRudesheim
			do:
			[ :anError |
				Rudesheim OpenCL Native Error BufferCreationFailed
					signalForCause:	anError
					context:			aCLContext
					options:			aCLTBufferDefineCollection
					sizeInBytes:		aByteArray byteSize.
			]
	)
		hostByteArray:	aByteArray;
		yourself.

]

{ #category : 'accessing' }
BufferOpenCLRudesheim class >> functionsOfCreationAndRelease [

	^ Rudesheim OpenCL Native Functions functionsOfBuffer.
]

{ #category : 'instance creation' }
BufferOpenCLRudesheim class >> newWithArguments:	aArgumentsSequencialCollection [
	
	^ self shouldNotImplement.
]

{ #category : 'converting' }
BufferOpenCLRudesheim >> asArray [
	"Downloads this buffer's content into a plain Array. Requires count/queue to
	already be set -- see the comments on the count:/queue: setters. Does not
	release the buffer; see class comment / note/opencl-layer-buffer-passthrough-design.md
	for the ownership rules that decide who does."

	^ self queue
		readFloatsFrom:	self
		count:				self count.
]

{ #category : 'converting' }
BufferOpenCLRudesheim >> asOpenCLBufferRudesheim: aContextOpenCLRudesheim [
	"Already an OpenCL buffer -- no upload needed. This assumes a single
	shared context/device, which is all this codebase currently has; a
	genuinely different context would need real conversion here."

	^ self
]

{ #category : 'converting' }
BufferOpenCLRudesheim >> asValueForCL [

	^ self handlePointer.
]

{ #category : 'converting' }
BufferOpenCLRudesheim >> rudesheimConcatenatedWith: anotherValue [
	"GPU-side counterpart to SequenceableCollection>>rudesheimConcatenatedWith: --
	merges self with anotherValue into one new buffer entirely via
	CommandQueueOpenCLRudesheim>>enqueueCopyFrom:offset:to:forRange:as:, without
	downloading either side to the host. anotherValue is uploaded first only if
	it isn't already an OpenCL buffer (asOpenCLBufferRudesheim: is a no-op in
	that case); a private upload created that way is released again once copied
	in, but anotherValue itself (if it was already a buffer) is left for its
	caller to release, same ownership rule as asArray/asOpenCLBufferRudesheim:.
	See note/opencl-layer-buffer-passthrough-design.md, 'AddLayerの分岐合流'."

	|
		anotherBuffer
		combinedBuffer
		combinedCount
		copyEvent
	|

	anotherBuffer := anotherValue asOpenCLBufferRudesheim: self context.
	combinedCount := self count + anotherBuffer count.
	combinedBuffer := self context newCLBufferForSize: combinedCount * TFBasicType float byteSize.
	combinedBuffer
		count:		combinedCount;
		queue:		self queue;
		context:	self context.

	"Each enqueueCopyFrom: returns a fresh Event that waiting on alone does
	not release (see CommandQueueOpenCLRudesheim>>enqueueKernelAndWait:
	forNDRange:withArguments:) -- release it explicitly once waited on, so
	an Add-heavy forward: pass doesn't leak one native Event per merge."
	copyEvent :=
		self queue
			enqueueCopyFrom:	self
			offset:				0
			to:					combinedBuffer
			forRange:			(1 to: self count)
			as:					TFBasicType float.
	copyEvent wait.
	copyEvent release.

	copyEvent :=
		self queue
			enqueueCopyFrom:	anotherBuffer
			offset:				0
			to:					combinedBuffer
			forRange:			(self count + 1 to: combinedCount)
			as:					TFBasicType float.
	copyEvent wait.
	copyEvent release.

	anotherBuffer == anotherValue
		ifFalse: [ anotherBuffer release ].

	^ combinedBuffer
]

{ #category : 'accessing' }
BufferOpenCLRudesheim >> context [

	^ context
]

{ #category : 'accessing' }
BufferOpenCLRudesheim >> context: aContextOpenCLRudesheim [
	"OpenCL context this buffer was allocated in -- needed (alongside queue) so
	rudesheimConcatenatedWith: can allocate a same-context destination buffer
	without a caller having to pass one in explicitly. See the comment on
	count:/queue: for the same self-describing-buffer rationale."

	context := aContextOpenCLRudesheim
]

{ #category : 'accessing' }
BufferOpenCLRudesheim >> count [

	^ count
]

{ #category : 'accessing' }
BufferOpenCLRudesheim >> count: anInteger [
	"Number of float elements this buffer holds -- the buffer's native handle
	has no self-describing size, so a Layer that creates a buffer as its
	forward: output must set this (and queue:) before returning it, so a
	later asArray knows how much to download."

	count := anInteger
]

{ #category : 'accessing' }
BufferOpenCLRudesheim >> hostByteArray [

	^ hostByteArray
]

{ #category : 'accessing' }
BufferOpenCLRudesheim >> hostByteArray: aByteArray [
	"Only ever set by class>>clBufferWith:options:of: for a buffer created with a host pointer
	(typically CL_MEM_USE_HOST_PTR) -- see the comment there. Purely a liveness anchor: nothing
	reads this back. Without it, the ByteArray backing the buffer's native host pointer has no
	Smalltalk-side reference once the creating method returns, so it is ordinary reachable-from-
	nowhere garbage; being pinned (Object>>pinInMemory, done by ByteArray>>tfPointerAddress) only
	stops it from being *moved*, not from being *collected*. Holding the reference here keeps it
	alive for exactly the buffer's own lifetime."

	hostByteArray := aByteArray
]

{ #category : 'accessing' }
BufferOpenCLRudesheim >> queue [

	^ queue
]

{ #category : 'accessing' }
BufferOpenCLRudesheim >> queue: aCommandQueueOpenCLRudesheim [
	"See the comment on count:."

	queue := aCommandQueueOpenCLRudesheim
]

{ #category : 'releasing' }
BufferOpenCLRudesheim >> releaseRudesheim [
	"Polymorphic counterpart to SequenceableCollection>>releaseRudesheim (a
	no-op there) -- lets code that may be holding either a plain Array or a
	BufferOpenCLRudesheim release unconditionally without a kind check."

	self release.
]

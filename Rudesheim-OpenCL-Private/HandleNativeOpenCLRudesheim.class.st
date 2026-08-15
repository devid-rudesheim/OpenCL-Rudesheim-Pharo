Class {
	#name : 'HandleNativeOpenCLRudesheim',
	#superclass : 'Object',
	#traits : 'TShouldntNewUtilityRudesheim',
	#classTraits : 'TShouldntNewUtilityRudesheim classTrait',
	#instVars : [
		'handlePointer'
	],
	#category : 'Rudesheim-OpenCL-Private-Native',
	#package : 'Rudesheim-OpenCL-Private',
	#tag : 'Native'
}

{ #category : 'finalization' }
HandleNativeOpenCLRudesheim class >> finalizeResourceData: aCollection [ 

	Rudesheim OpenCL Native Functions tfRunner
		invokeFunction:	self functionsOfCreationAndRelease first
		withArguments:
		{
			aCollection first
		}.
]

{ #category : 'accessing' }
HandleNativeOpenCLRudesheim class >> functionsOfCreationAndRelease [

	^ self subclassResponsibility.
]

{ #category : 'instance creation' }
HandleNativeOpenCLRudesheim class >> newWithArguments:	anArgumentsSequencialCollection [

	^ self
		onDo:
		[ :errorOutput |
			
			Rudesheim OpenCL Native Functions tfRunner
				invokeFunction:	self functionsOfCreationAndRelease last
				withArguments:
				(
					anArgumentsSequencialCollection
						copyWith:	errorOutput
				)

		].
]

{ #category : 'enumerating' }
HandleNativeOpenCLRudesheim class >> onDo:	aBlock [
	|
		handle
		errorOutput
		sint32
	|

	sint32 := TFBasicType sint32.
	errorOutput :=
		ExternalAddress
			gcallocate: sint32 byteSize.
	
	sint32
		write: 	0
		into: 	errorOutput.
	
	handle :=
		aBlock
			value:	errorOutput.

	Rudesheim OpenCL Native Error Primitive
		shouldZero:
		[
			sint32
				readValue: errorOutput
		].

	^ super new
		setHandle: 	handle;
		yourself.
]

{ #category : 'finalization' }
HandleNativeOpenCLRudesheim >> finalize [

	self
		traceCr: 'One'.
]

{ #category : 'finalization' }
HandleNativeOpenCLRudesheim >> finalizeResourceData [

	self
		traceCr: 'Three'.
]

{ #category : 'accessing' }
HandleNativeOpenCLRudesheim >> handlePointer [

	^ handlePointer
]

{ #category : 'releasing' }
HandleNativeOpenCLRudesheim >> release [

	handlePointer ifNil: [ ^ self ].

	self class finalizeResourceData: { handlePointer }.
	FFIExternalResourceManager uniqueInstance removeResource: self.
	handlePointer := nil.
]

{ #category : 'finalization' }
HandleNativeOpenCLRudesheim >> resourceData [

	^
	{
		handlePointer
	}.
]

{ #category : 'initialization' }
HandleNativeOpenCLRudesheim >> setHandle: aPointer [

	super initialize.
"
	self class finalizationRegistry
		add: self.
"
	handlePointer := aPointer.
	FFIExternalResourceManager
		addResource:	self
		data:
		{
			handlePointer
		}.

]

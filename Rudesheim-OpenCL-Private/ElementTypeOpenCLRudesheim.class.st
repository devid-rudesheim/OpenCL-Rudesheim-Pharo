Class {
	#name : 'ElementTypeOpenCLRudesheim',
	#superclass : 'Object',
	#category : 'Rudesheim-OpenCL-Private-Namespace',
	#package : 'Rudesheim-OpenCL-Private',
	#tag : 'Namespace'
}

{ #category : 'namespace' }
ElementTypeOpenCLRudesheim class >> Double [

	^ DoubleElementTypeOpenCLRudesheim.
]

{ #category : 'namespace' }
ElementTypeOpenCLRudesheim class >> Float [

	^ FloatElementTypeOpenCLRudesheim.
]

{ #category : 'namespace' }
ElementTypeOpenCLRudesheim class >> NotSupported [

	^ ElementTypeNotSupportedOpenCLRudesheim.
]

{ #category : 'namespace' }
ElementTypeOpenCLRudesheim class >> SInt16 [

	^ SInt16ElementTypeOpenCLRudesheim.
]

{ #category : 'namespace' }
ElementTypeOpenCLRudesheim class >> SInt32 [

	^ SInt32ElementTypeOpenCLRudesheim.
]

{ #category : 'namespace' }
ElementTypeOpenCLRudesheim class >> SInt64 [

	^ SInt64ElementTypeOpenCLRudesheim.
]

{ #category : 'namespace' }
ElementTypeOpenCLRudesheim class >> SInt8 [

	^ SInt8ElementTypeOpenCLRudesheim.
]

{ #category : 'namespace' }
ElementTypeOpenCLRudesheim class >> UInt16 [

	^ UInt16ElementTypeOpenCLRudesheim.
]

{ #category : 'namespace' }
ElementTypeOpenCLRudesheim class >> UInt32 [

	^ UInt32ElementTypeOpenCLRudesheim.
]

{ #category : 'namespace' }
ElementTypeOpenCLRudesheim class >> UInt64 [

	^ UInt64ElementTypeOpenCLRudesheim.
]

{ #category : 'namespace' }
ElementTypeOpenCLRudesheim class >> UInt8 [

	^ UInt8ElementTypeOpenCLRudesheim.
]

{ #category : 'accessing' }
ElementTypeOpenCLRudesheim class >> forInteger: aTFIntType [

	^ self integerElementTypes
		detect:
		[ :eachElementTypeClass |
			eachElementTypeClass
				byteSize
				= aTFIntType byteSize
				and:
				[
					eachElementTypeClass
						signed
						= aTFIntType signed.
				].
		]
		ifNone:
		[
			self NotSupported
				signalForElementType:	aTFIntType.
		].
]

{ #category : 'accessing' }
ElementTypeOpenCLRudesheim class >> integerElementTypes [

	^ {self UInt8 .  self UInt16 .  self UInt32 .  self UInt64 .  self SInt8 .  self SInt16 .  self SInt32 .  self SInt64}.
]

Class {
	#name : 'UInt8ElementTypeOpenCLRudesheim',
	#superclass : 'Object',
	#traits : 'TElementTypeOpenCLRudesheim',
	#classTraits : 'TElementTypeOpenCLRudesheim classTrait',
	#category : 'Rudesheim-OpenCL-Private-Defines-ElementType',
	#package : 'Rudesheim-OpenCL-Private',
	#tag : 'Defines-ElementType'
}

{ #category : 'accessing' }
UInt8ElementTypeOpenCLRudesheim class >> byteSize [

	^ 1.
]

{ #category : 'accessing' }
UInt8ElementTypeOpenCLRudesheim class >> signed [

	^ false.
]

{ #category : 'writing' }
UInt8ElementTypeOpenCLRudesheim class >> writeValue:	aNumber
intoByteArray:	aByteArray
atOffset:	anInteger [

	^ aByteArray
		uint8AtOffset:	anInteger
		put:	aNumber asInteger.
]

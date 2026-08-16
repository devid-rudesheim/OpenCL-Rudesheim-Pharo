Class {
	#name : 'UInt16ElementTypeOpenCLRudesheim',
	#superclass : 'Object',
	#traits : 'TElementTypeOpenCLRudesheim',
	#classTraits : 'TElementTypeOpenCLRudesheim classTrait',
	#category : 'Rudesheim-OpenCL-Private-Defines-ElementType',
	#package : 'Rudesheim-OpenCL-Private',
	#tag : 'Defines-ElementType'
}

{ #category : 'accessing' }
UInt16ElementTypeOpenCLRudesheim class >> byteSize [

	^ 2.
]

{ #category : 'accessing' }
UInt16ElementTypeOpenCLRudesheim class >> signed [

	^ false.
]

{ #category : 'reading' }
UInt16ElementTypeOpenCLRudesheim class >> readValue:	aByteArrayOrExternalAddress
atOffset:	anInteger [

	^ aByteArrayOrExternalAddress
		uint16AtOffset:	anInteger.
]

{ #category : 'writing' }
UInt16ElementTypeOpenCLRudesheim class >> writeValue:	aNumber
intoByteArray:	aByteArray
atOffset:	anInteger [

	^ aByteArray
		uint16AtOffset:	anInteger
		put:	aNumber asInteger.
]

Class {
	#name : 'UInt64ElementTypeOpenCLRudesheim',
	#superclass : 'Object',
	#traits : 'TElementTypeOpenCLRudesheim',
	#classTraits : 'TElementTypeOpenCLRudesheim classTrait',
	#category : 'Rudesheim-OpenCL-Private-Defines-ElementType',
	#package : 'Rudesheim-OpenCL-Private',
	#tag : 'Defines-ElementType'
}

{ #category : 'accessing' }
UInt64ElementTypeOpenCLRudesheim class >> byteSize [

	^ 8.
]

{ #category : 'accessing' }
UInt64ElementTypeOpenCLRudesheim class >> signed [

	^ false.
]

{ #category : 'reading' }
UInt64ElementTypeOpenCLRudesheim class >> readValue:	aByteArrayOrExternalAddress
atOffset:	anInteger [

	^ aByteArrayOrExternalAddress
		uint64AtOffset:	anInteger.
]

{ #category : 'writing' }
UInt64ElementTypeOpenCLRudesheim class >> writeValue:	aNumber
intoByteArray:	aByteArray
atOffset:	anInteger [

	^ aByteArray
		uint64AtOffset:	anInteger
		put:	aNumber asInteger.
]

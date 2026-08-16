Class {
	#name : 'UInt32ElementTypeOpenCLRudesheim',
	#superclass : 'Object',
	#traits : 'TElementTypeOpenCLRudesheim',
	#classTraits : 'TElementTypeOpenCLRudesheim classTrait',
	#category : 'Rudesheim-OpenCL-Private-Defines-ElementType',
	#package : 'Rudesheim-OpenCL-Private',
	#tag : 'Defines-ElementType'
}

{ #category : 'accessing' }
UInt32ElementTypeOpenCLRudesheim class >> byteSize [

	^ 4.
]

{ #category : 'accessing' }
UInt32ElementTypeOpenCLRudesheim class >> signed [

	^ false.
]

{ #category : 'reading' }
UInt32ElementTypeOpenCLRudesheim class >> readValue:	aByteArrayOrExternalAddress
atOffset:	anInteger [

	^ aByteArrayOrExternalAddress
		uint32AtOffset:	anInteger.
]

{ #category : 'writing' }
UInt32ElementTypeOpenCLRudesheim class >> writeValue:	aNumber
intoByteArray:	aByteArray
atOffset:	anInteger [

	^ aByteArray
		uint32AtOffset:	anInteger
		put:	aNumber asInteger.
]

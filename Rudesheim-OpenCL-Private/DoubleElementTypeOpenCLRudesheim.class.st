Class {
	#name : 'DoubleElementTypeOpenCLRudesheim',
	#superclass : 'Object',
	#traits : 'TElementTypeOpenCLRudesheim',
	#classTraits : 'TElementTypeOpenCLRudesheim classTrait',
	#category : 'Rudesheim-OpenCL-Private-Defines-ElementType',
	#package : 'Rudesheim-OpenCL-Private',
	#tag : 'Defines-ElementType'
}

{ #category : 'accessing' }
DoubleElementTypeOpenCLRudesheim class >> byteSize [

	^ 8.
]

{ #category : 'reading' }
DoubleElementTypeOpenCLRudesheim class >> readValue:	aByteArrayOrExternalAddress
atOffset:	anInteger [

	^ aByteArrayOrExternalAddress
		float64AtOffset:	anInteger.
]

{ #category : 'writing' }
DoubleElementTypeOpenCLRudesheim class >> writeValue:	aNumber
intoByteArray:	aByteArray
atOffset:	anInteger [

	^ aByteArray
		float64AtOffset:	anInteger
		put:	aNumber asFloat.
]

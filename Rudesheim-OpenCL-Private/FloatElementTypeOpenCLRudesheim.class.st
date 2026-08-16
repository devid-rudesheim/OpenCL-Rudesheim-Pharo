Class {
	#name : 'FloatElementTypeOpenCLRudesheim',
	#superclass : 'Object',
	#traits : 'TElementTypeOpenCLRudesheim',
	#classTraits : 'TElementTypeOpenCLRudesheim classTrait',
	#category : 'Rudesheim-OpenCL-Private-Defines-ElementType',
	#package : 'Rudesheim-OpenCL-Private',
	#tag : 'Defines-ElementType'
}

{ #category : 'accessing' }
FloatElementTypeOpenCLRudesheim class >> byteSize [

	^ 4.
]

{ #category : 'reading' }
FloatElementTypeOpenCLRudesheim class >> readValue:	aByteArrayOrExternalAddress
atOffset:	anInteger [

	^ aByteArrayOrExternalAddress
		float32AtOffset:	anInteger.
]

{ #category : 'writing' }
FloatElementTypeOpenCLRudesheim class >> writeValue:	aNumber
intoByteArray:	aByteArray
atOffset:	anInteger [

	^ aByteArray
		float32AtOffset:	anInteger
		put:	aNumber asFloat.
]

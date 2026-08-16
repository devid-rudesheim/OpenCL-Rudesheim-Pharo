Class {
	#name : 'SInt8ElementTypeOpenCLRudesheim',
	#superclass : 'Object',
	#traits : 'TElementTypeOpenCLRudesheim',
	#classTraits : 'TElementTypeOpenCLRudesheim classTrait',
	#category : 'Rudesheim-OpenCL-Private-Defines-ElementType',
	#package : 'Rudesheim-OpenCL-Private',
	#tag : 'Defines-ElementType'
}

{ #category : 'accessing' }
SInt8ElementTypeOpenCLRudesheim class >> byteSize [

	^ 1.
]

{ #category : 'accessing' }
SInt8ElementTypeOpenCLRudesheim class >> signed [

	^ true.
]

{ #category : 'writing' }
SInt8ElementTypeOpenCLRudesheim class >> writeValue:	aNumber
intoByteArray:	aByteArray
atOffset:	anInteger [

	^ aByteArray
		int8AtOffset:	anInteger
		put:	aNumber asInteger.
]

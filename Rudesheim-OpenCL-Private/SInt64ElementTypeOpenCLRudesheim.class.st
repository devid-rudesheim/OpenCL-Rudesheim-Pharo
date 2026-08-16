Class {
	#name : 'SInt64ElementTypeOpenCLRudesheim',
	#superclass : 'Object',
	#traits : 'TElementTypeOpenCLRudesheim',
	#classTraits : 'TElementTypeOpenCLRudesheim classTrait',
	#category : 'Rudesheim-OpenCL-Private-Defines-ElementType',
	#package : 'Rudesheim-OpenCL-Private',
	#tag : 'Defines-ElementType'
}

{ #category : 'accessing' }
SInt64ElementTypeOpenCLRudesheim class >> byteSize [

	^ 8.
]

{ #category : 'accessing' }
SInt64ElementTypeOpenCLRudesheim class >> signed [

	^ true.
]

{ #category : 'writing' }
SInt64ElementTypeOpenCLRudesheim class >> writeValue:	aNumber
intoByteArray:	aByteArray
atOffset:	anInteger [

	^ aByteArray
		int64AtOffset:	anInteger
		put:	aNumber asInteger.
]

Class {
	#name : 'SInt32ElementTypeOpenCLRudesheim',
	#superclass : 'Object',
	#traits : 'TElementTypeOpenCLRudesheim',
	#classTraits : 'TElementTypeOpenCLRudesheim classTrait',
	#category : 'Rudesheim-OpenCL-Private-Defines-ElementType',
	#package : 'Rudesheim-OpenCL-Private',
	#tag : 'Defines-ElementType'
}

{ #category : 'accessing' }
SInt32ElementTypeOpenCLRudesheim class >> byteSize [

	^ 4.
]

{ #category : 'accessing' }
SInt32ElementTypeOpenCLRudesheim class >> signed [

	^ true.
]

{ #category : 'writing' }
SInt32ElementTypeOpenCLRudesheim class >> writeValue: aNumber
intoByteArray: aByteArray
atOffset: anInteger [

	^ aByteArray
		int32AtOffset:	anInteger
		put:	aNumber asInteger.
]

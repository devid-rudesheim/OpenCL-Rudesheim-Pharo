Class {
	#name : 'SInt16ElementTypeOpenCLRudesheim',
	#superclass : 'Object',
	#traits : 'TElementTypeOpenCLRudesheim',
	#classTraits : 'TElementTypeOpenCLRudesheim classTrait',
	#category : 'Rudesheim-OpenCL-Private-Defines-ElementType',
	#package : 'Rudesheim-OpenCL-Private',
	#tag : 'Defines-ElementType'
}

{ #category : 'accessing' }
SInt16ElementTypeOpenCLRudesheim class >> byteSize [
	^ 2.
]

{ #category : 'reading' }
SInt16ElementTypeOpenCLRudesheim class >> readValue: aByteArrayOrExternalAddress
atOffset: anInteger [
	^ aByteArrayOrExternalAddress
		int16AtOffset:	anInteger.
]

{ #category : 'accessing' }
SInt16ElementTypeOpenCLRudesheim class >> signed [
	^ true.
]

{ #category : 'writing' }
SInt16ElementTypeOpenCLRudesheim class >> writeValue: aNumber
intoByteArray: aByteArray
atOffset: anInteger [
	^ aByteArray
		int16AtOffset:	anInteger
		put:	aNumber asInteger.
]

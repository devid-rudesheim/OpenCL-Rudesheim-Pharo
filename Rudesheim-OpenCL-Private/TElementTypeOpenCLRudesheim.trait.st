Trait {
	#name : 'TElementTypeOpenCLRudesheim',
	#category : 'Rudesheim-OpenCL-Private-Defines-ElementType',
	#package : 'Rudesheim-OpenCL-Private',
	#tag : 'Defines-ElementType'
}

{ #category : 'accessing' }
TElementTypeOpenCLRudesheim classSide >> byteSize [

	^ self subclassResponsibility.
]

{ #category : 'writing' }
TElementTypeOpenCLRudesheim classSide >> writeElementsOf:	aCollection
intoByteArray:	aByteArray [

	aCollection
		withIndexDo:
		[ :each :index |
			self
				writeValue:	each
				intoByteArray:	aByteArray
				atOffset:
				index
					- 1
					* self byteSize.
		].
]

{ #category : 'writing' }
TElementTypeOpenCLRudesheim classSide >> writeValue:	aNumber
intoByteArray:	aByteArray
atOffset:	anInteger [

	^ self subclassResponsibility.
]

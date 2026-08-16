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

{ #category : 'reading' }
TElementTypeOpenCLRudesheim classSide >> readElementsFrom:	aByteArrayOrExternalAddress
count:	aCountInteger [

	|
		result
	|

	result := Array new: aCountInteger.
	1
		to: aCountInteger
		do:
		[ :index |
			result
				at:	index
				put:
				(
					self
						readValue:	aByteArrayOrExternalAddress
						atOffset:
						index
							- 1
							* self byteSize
				).
		].
	^ result.
]

{ #category : 'reading' }
TElementTypeOpenCLRudesheim classSide >> readValue:	aByteArrayOrExternalAddress
atOffset:	anInteger [

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

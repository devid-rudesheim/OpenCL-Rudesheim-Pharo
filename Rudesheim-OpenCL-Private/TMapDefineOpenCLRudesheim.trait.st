Trait {
	#name : 'TMapDefineOpenCLRudesheim',
	#category : 'Rudesheim-OpenCL-Private-Defines-Buffer',
	#package : 'Rudesheim-OpenCL-Private',
	#tag : 'Defines-Buffer'
}

{ #category : 'accessing' }
TMapDefineOpenCLRudesheim classSide >> clMapType [

	^ 1
		bitShift:	self offsetOfCLMapType.
]

{ #category : 'accessing' }
TMapDefineOpenCLRudesheim classSide >> offsetOfCLMapType [

	^ self subclassResponsibility.
]

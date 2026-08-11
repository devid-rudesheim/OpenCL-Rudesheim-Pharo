Trait {
	#name : 'TBufferDefineOpenCLRudesheim',
	#category : 'Rudesheim-OpenCL-Private-Defines-Buffer',
	#package : 'Rudesheim-OpenCL-Private',
	#tag : 'Defines-Buffer'
}

{ #category : 'accessing' }
TBufferDefineOpenCLRudesheim classSide >> clBufferType [

	^ 1
		bitShift:	self offsetOfCLBufferType.
]

{ #category : 'accessing' }
TBufferDefineOpenCLRudesheim classSide >> offsetOfCLBufferType [

	^ self subclassResponsibility.
]

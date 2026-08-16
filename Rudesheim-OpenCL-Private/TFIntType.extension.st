Extension { #name : 'TFIntType' }

{ #category : '*Rudesheim-OpenCL-Private' }
TFIntType >> openCLElementTypeRudesheim [

	^ Rudesheim OpenCL ElementType
		forInteger:	self.
]

Extension { #name : 'TFBasicType' }

{ #category : '*Rudesheim-OpenCL-Private' }
TFBasicType >> openCLElementTypeRudesheim [

	^ Rudesheim
		OpenCL
		ElementType
		NotSupported
		signalForElementType:	self.
]

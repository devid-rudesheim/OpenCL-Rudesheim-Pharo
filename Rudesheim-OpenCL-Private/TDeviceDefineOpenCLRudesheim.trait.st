Trait {
	#name : 'TDeviceDefineOpenCLRudesheim',
	#category : 'Rudesheim-OpenCL-Private-Defines-Device',
	#package : 'Rudesheim-OpenCL-Private',
	#tag : 'Defines-Device'
}

{ #category : 'accessing' }
TDeviceDefineOpenCLRudesheim classSide >> clDeviceType [

	^ 1
		bitShift:	self offsetOfCLDeviceType.
]

{ #category : 'accessing' }
TDeviceDefineOpenCLRudesheim classSide >> offsetOfCLDeviceType [

	^ self subclassResponsibility.
]

{ #category : 'accessing' }
TDeviceDefineOpenCLRudesheim >> clDeviceType [

	^ self class clDeviceType.
]

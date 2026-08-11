"
Supplies the shared clProgramBuildInfo accessor for concrete classes representing a clGetProgramBuildInfo param_name value (e.g. BuildLogOpenCLRudesheim). Each concrete class overrides the class-side clProgramBuildInfo directly with its raw OpenCL constant value.
"
Trait {
	#name : 'TProgramBuildInfoDefineOpenCLRudesheim',
	#category : 'Rudesheim-OpenCL-Private-Defines-Program',
	#package : 'Rudesheim-OpenCL-Private',
	#tag : 'Defines-Program'
}

{ #category : 'accessing' }
TProgramBuildInfoDefineOpenCLRudesheim classSide >> clProgramBuildInfo [
	^ self subclassResponsibility.
]

{ #category : 'accessing' }
TProgramBuildInfoDefineOpenCLRudesheim >> clProgramBuildInfo [
	^ self class clProgramBuildInfo.
]

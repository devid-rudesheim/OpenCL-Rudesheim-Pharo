"
Represents CL_PROGRAM_BUILD_LOG (4483), the param_name value passed to clGetProgramBuildInfo to retrieve a program's compile/link/build log.
"
Class {
	#name : 'BuildLogOpenCLRudesheim',
	#superclass : 'Object',
	#traits : 'TProgramBuildInfoDefineOpenCLRudesheim',
	#classTraits : 'TProgramBuildInfoDefineOpenCLRudesheim classTrait',
	#category : 'Rudesheim-OpenCL-Private-Defines-Program',
	#package : 'Rudesheim-OpenCL-Private',
	#tag : 'Defines-Program'
}

{ #category : 'accessing' }
BuildLogOpenCLRudesheim class >> clProgramBuildInfo [
	^ 16r1183.
]

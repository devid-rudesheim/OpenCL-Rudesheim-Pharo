"
Overrides OSOpenCLRudesheim (its superclass) to raise immediately, without ever calling the native clCompileProgram/clLinkProgram - this Mac''s OpenCL implementation crashes the whole process in clCompileProgram (confirmed: Abort trap 6 inside AppleMetalOpenGLRenderer gldDestroyComputeModule, even for trivial valid input) and silently returns a null handle from clLinkProgram despite reporting success. Both are known limitations of Apple''s incomplete OpenCL 1.2 separate-compilation support, not bugs in this code. Reached as `Smalltalk os rudesheim openCL` on a Mac, or `Rudesheim OpenCL OS Mac` for reflective discovery.
"
Class {
	#name : 'MacOSOpenCLRudesheim',
	#superclass : 'OSOpenCLRudesheim',
	#category : 'Rudesheim-OpenCL-OS',
	#package : 'Rudesheim-OpenCL',
	#tag : 'OS'
}

{ #category : 'invoking' }
MacOSOpenCLRudesheim class >> invokeCompileProgram:	aProgramOpenCLRudesheim
for:					aCLDevicesCollection
withOptions:			anOptionsString
headers:				aHeaderAssociationsCollection
of:						aCLContext [

	^ Rudesheim OpenCL Native Error ProgramCompileNotSupported
		signalForProgram:	aProgramOpenCLRudesheim
		devices:			aCLDevicesCollection
		options:			anOptionsString
		headers:			aHeaderAssociationsCollection.
]

{ #category : 'invoking' }
MacOSOpenCLRudesheim class >> invokeLinkProgramFor:	aCLContext
devices:				aCLDevicesCollection
programs:				aProgramsCollection
options:				anOptionsString
errorOutput:			errorOutput [

	^ Rudesheim OpenCL Native Error ProgramLinkNotSupported
		signalForContext:	aCLContext
		devices:			aCLDevicesCollection
		programs:			aProgramsCollection
		options:			anOptionsString.
]

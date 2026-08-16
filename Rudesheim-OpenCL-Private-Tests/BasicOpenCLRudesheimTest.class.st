"
A BasicOpenCLRudesheimTest is the shared superclass for OpenCL test cases that need to build a
CL program - it centralizes the `-cl-std=` build option so every test targets the same OpenCL C
language version.
"
Class {
	#name : 'BasicOpenCLRudesheimTest',
	#superclass : 'BasicRudesheimTest',
	#category : 'Rudesheim-OpenCL-Private-Tests-Objects',
	#package : 'Rudesheim-OpenCL-Private-Tests',
	#tag : 'Objects'
}

{ #category : 'accessing' }
BasicOpenCLRudesheimTest class >> isAbstract [
	^ self = BasicOpenCLRudesheimTest.
]

{ #category : 'accessing' }
BasicOpenCLRudesheimTest >> defaultCLStdOption [

	^ '-cl-std=CL3.0'
]

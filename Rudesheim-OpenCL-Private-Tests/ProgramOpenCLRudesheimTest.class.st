"
A ProgramOpenCLRudesheimTest is a test class for testing the behavior of ProgramOpenCLRudesheim
"
Class {
	#name : 'ProgramOpenCLRudesheimTest',
	#superclass : 'BasicOpenCLRudesheimTest',
	#instVars : [
		'clDevices',
		'clContext'
	],
	#category : 'Rudesheim-OpenCL-Private-Tests-Objects',
	#package : 'Rudesheim-OpenCL-Private-Tests',
	#tag : 'Objects'
}

{ #category : 'accessing' }
ProgramOpenCLRudesheimTest class >> targetClass [

	^ ProgramOpenCLRudesheim.
]

{ #category : 'accessing' }
ProgramOpenCLRudesheimTest >> clContext [

	^ clContext
		ifNil:
		[
			clContext := self defaultCLContext.
		].

]

{ #category : 'accessing' }
ProgramOpenCLRudesheimTest >> clDevices [

	^ clDevices
		ifNil:
		[
			clDevices := self defaultCLDevices.
		].

]

{ #category : 'accessing' }
ProgramOpenCLRudesheimTest >> defaultBasicTarget [

	^ self
		trackForRelease:
		(
			self clContext
				buildCLProgramFor:	self clDevices
				fromSources:
				{
					'
kernel void Zero()
{
}
					'
				}
				withOptions:	self defaultCLStdOption
		).
]

{ #category : 'accessing' }
ProgramOpenCLRudesheimTest >> defaultCLContext [

	^ self
		trackForRelease:
		(
			Rudesheim OpenCL Context
				clContextFor:	self clDevices
		).

]

{ #category : 'accessing' }
ProgramOpenCLRudesheimTest >> defaultCLDevices [

	^ Rudesheim OpenCL Platform clPlatforms first clDevices.

]

{ #category : 'tests' }
ProgramOpenCLRudesheimTest >> runNewCLKernelAtWithParameterTypes0 [
	|
		cl
		program
		devices
	|

	cl := Rudesheim OpenCL.
	devices := cl Platform clPlatforms first clDevices.

	program :=
		self
			trackForRelease:
			(
				cl Program
					buildCLProgramFor: devices
					fromSources:
					{
						'
kernel void One()
{
}

kernel void Two()
{
}
						'
					}
					withOptions:	self defaultCLStdOption
					of:
					(
						self
							trackForRelease:
							(
								cl Context
									clContextFor:	devices
							)
					)
			).

	self
		trackForRelease:
		(
			program
				newCLKernelAt:	self sourceValue
				withParameterTypes:
				{
				}
		).
]

{ #category : 'tests' }
ProgramOpenCLRudesheimTest >> testBuildCLProgramForFromSourcesWithOptionsOfDetailedBuildLog [
	|
		cl
		devices
		context
		caughtError
	|

	cl := Rudesheim OpenCL.
	devices := cl Platform clPlatforms first clDevices.
	context := self trackForRelease: (cl Context clContextFor: devices).

	caughtError :=
		[
			context
				buildCLProgramFor:	devices
				fromSources:
				{
					'kernel void Broken( global unsigned int *output ) { output[0] = ; }'
				}
				withOptions:	self defaultCLStdOption.
			nil.
		]
			on: ProgramBuildFailedOpenCLRudesheim
			do:
			[ :anError |
				anError.
			].

	self
		assert:	caughtError notNil.
	self
		assert:	( caughtError buildLog includesSubstring: 'expected expression' ).
	self
		assert:	( caughtError messageText includesSubstring: 'build log:' ).
]

{ #category : 'tests' }
ProgramOpenCLRudesheimTest >> testCompileCLProgramForFromSourcesWithOptionsHeadersOfNotSupportedOnMac [
	|
		cl
		devices
		context
	|

	cl := Rudesheim OpenCL.
	devices := cl Platform clPlatforms first clDevices.
	context := self trackForRelease: (cl Context clContextFor: devices).

	( Smalltalk os rudesheim openCLTestAsserter )
		for:	self
		should:
		[
			context
				compileCLProgramFor:	devices
				fromSources:
				{
					'kernel void NeverCompiled() { }'
				}
				withOptions:	self defaultCLStdOption
				headers:		{ }.
		]
		raiseCompileOrLinkError:	Rudesheim OpenCL Native Error ProgramCompileNotSupported.
]

{ #category : 'tests' }
ProgramOpenCLRudesheimTest >> testNewCLKernelAtWithParameterTypes [

	self
		testNewCLKernelAtWithParameterTypes0_0;
		tearDown;
		setUp;
		testNewCLKernelAtWithParameterTypes0_1;
		tearDown;
		setUp;
		testNewCLKernelAtWithParameterTypes0_2.
]

{ #category : 'tests' }
ProgramOpenCLRudesheimTest >> testNewCLKernelAtWithParameterTypes0_0 [

	self
		should:
		[
			self
				sourceValue:	'Three';
				runNewCLKernelAtWithParameterTypes0.
		]
		raise: Rudesheim OpenCL Native Error Primitive.

]

{ #category : 'tests' }
ProgramOpenCLRudesheimTest >> testNewCLKernelAtWithParameterTypes0_0Detailed [
	|
		caughtError
	|

	caughtError :=
		[
			self
				sourceValue:	'Three';
				runNewCLKernelAtWithParameterTypes0.

			nil.
		]
			on: KernelCreationFailedOpenCLRudesheim
			do:
			[ :anError |
				anError.
			].

	self
		assert:	caughtError notNil.
	self
		assert:	caughtError kernelName
		equals:	'Three'.
	self
		assert:	( caughtError messageText includesSubstring: 'Three' ).
	self
		assert:	( caughtError messageText includesSubstring: 'invalid_kernel_name' ).

]

{ #category : 'tests' }
ProgramOpenCLRudesheimTest >> testNewCLKernelAtWithParameterTypes0_1 [

	self
		sourceValue:	'One';
		runNewCLKernelAtWithParameterTypes0.

]

{ #category : 'tests' }
ProgramOpenCLRudesheimTest >> testNewCLKernelAtWithParameterTypes0_2 [

	self
		sourceValue:	'Two';
		runNewCLKernelAtWithParameterTypes0.
]

{ #category : 'tests' }
ProgramOpenCLRudesheimTest >> testNewCLProgramByLinkingForWithOptionsNotSupportedOnMac [
	|
		cl
		devices
		context
		program
	|

	cl := Rudesheim OpenCL.
	devices := cl Platform clPlatforms first clDevices.
	context := self trackForRelease: (cl Context clContextFor: devices).

	program :=
		self
			trackForRelease:
			(
				context
					buildCLProgramFor:	devices
					fromSources:
					{
						'kernel void NeverLinked() { }'
					}
					withOptions:	self defaultCLStdOption
			).

	( Smalltalk os rudesheim openCLTestAsserter )
		for:	self
		should:
		[
			context
				newCLProgramByLinking:
				{
					program
				}
				for:				devices
				withOptions:		''.
		]
		raiseCompileOrLinkError:	Rudesheim OpenCL Native Error ProgramLinkNotSupported.
]

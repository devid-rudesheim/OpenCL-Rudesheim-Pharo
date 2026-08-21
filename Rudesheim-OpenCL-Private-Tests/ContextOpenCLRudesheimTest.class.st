"
A ContextOpenCLRudesheimTest is a test class for testing the behavior of ContextOpenCLRudesheim
"
Class {
	#name : 'ContextOpenCLRudesheimTest',
	#superclass : 'BasicOpenCLRudesheimTest',
	#instVars : [
		'clDevices'
	],
	#category : 'Rudesheim-OpenCL-Private-Tests-Objects',
	#package : 'Rudesheim-OpenCL-Private-Tests',
	#tag : 'Objects'
}

{ #category : 'accessing' }
ContextOpenCLRudesheimTest class >> targetClass [

	^ ContextOpenCLRudesheim.
]

{ #category : 'accessing' }
ContextOpenCLRudesheimTest >> clDevices [

	^ clDevices
		ifNil:
		[
			clDevices := self defaultCLDevices.
		].

]

{ #category : 'accessing' }
ContextOpenCLRudesheimTest >> defaultBasicTarget [

	^ self
		trackForRelease:
		(
			self targetClass
				clContextFor:	self clDevices
		).
]

{ #category : 'accessing' }
ContextOpenCLRudesheimTest >> defaultCLDevices [

	^ Rudesheim OpenCL Platform clPlatforms first clDevices.

]

{ #category : 'tests' }
ContextOpenCLRudesheimTest >> runBuildCLProgramForFromSourcesWithOptions0 [
	|
		program
	|

	program :=
		self
			trackForRelease:
			(
				self basicTarget
					buildCLProgramFor:	self clDevices
					fromSources:
					{
						'
kernel void Example()
{
}
						'
					}
					withOptions:		self defaultCLStdOption
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
ContextOpenCLRudesheimTest >> runNewCLBufferForSizeOptions0 [
	|
		cl
	|

	cl := Rudesheim OpenCL.

	(
		self
			trackForRelease:
			(
				self basicTarget
					newCLBufferForSize:	16r10
					options:
					{
						cl ReadWrite.
					}
			)
	) asValueForCL.
]

{ #category : 'tests' }
ContextOpenCLRudesheimTest >> runNewCLBufferWithOptions0 [
	|
		cl
		ouput
	|

	cl := Rudesheim OpenCL.

	ouput :=
		IntegerArray
			new: 16r10.
	(
		self
			trackForRelease:
			(
				self basicTarget
					newCLBufferWith:	ouput
					options:
					{
						cl ReadWrite.
						cl HostPtr Use.
					}
			)
	) asValueForCL.
]

{ #category : 'tests' }
ContextOpenCLRudesheimTest >> runNewCLCommandQueueFor0 [

	(
		self
			trackForRelease:
			(
				self basicTarget
					newCLCommandQueueFor:	self clDevices first
			)
	) finish.
]

{ #category : 'tests' }
ContextOpenCLRudesheimTest >> runNewCLEvent0 [

	(
		(
			self trackForRelease: self basicTarget newCLEvent
		)
			status:	0;
			yourself
	) wait.
]

{ #category : 'tests' }
ContextOpenCLRudesheimTest >> testBuildCLProgramForFromSourcesWithOptions [

	self
		testBuildCLProgramForFromSourcesWithOptions0_0.
]

{ #category : 'tests' }
ContextOpenCLRudesheimTest >> testBuildCLProgramForFromSourcesWithOptions0_0 [
	
	self
		sourceValue:	'Example';
		runBuildCLProgramForFromSourcesWithOptions0.
]

{ #category : 'tests' }
ContextOpenCLRudesheimTest >> testCachedCLKernelAtOfProgramWithParameterTypes0_0 [
	|
		program
		kernel1
		kernel2
	|

	program :=
		self
			trackForRelease:
			(
				self basicTarget
					cachedCLProgramFor:	self clDevices
					fromSources:
					{
						'kernel void CacheMeKernel() { }'
					}
					withOptions:	self defaultCLStdOption
			).

	kernel1 :=
		self
			trackForRelease:
			(
				self basicTarget
					cachedCLKernelAt:	'CacheMeKernel'
					ofProgram:			program
					withParameterTypes:
					{
					}
			).

	kernel2 :=
		self
			trackForRelease:
			(
				self basicTarget
					cachedCLKernelAt:	'CacheMeKernel'
					ofProgram:			program
					withParameterTypes:
					{
					}
			).

	self
		assert:	kernel1 == kernel2.
]

{ #category : 'tests' }
ContextOpenCLRudesheimTest >> testCachedCLProgramForFromSourcesWithOptions0_0 [
	|
		program1
		program2
		program3
	|

	program1 :=
		self
			trackForRelease:
			(
				self basicTarget
					cachedCLProgramFor:	self clDevices
					fromSources:
					{
						'kernel void CacheMe() { }'
					}
					withOptions:	self defaultCLStdOption
			).

	program2 :=
		self
			trackForRelease:
			(
				self basicTarget
					cachedCLProgramFor:	self clDevices
					fromSources:
					{
						'kernel void CacheMe() { }'
					}
					withOptions:	self defaultCLStdOption
			).

	program3 :=
		self
			trackForRelease:
			(
				self basicTarget
					cachedCLProgramFor:	self clDevices
					fromSources:
					{
						'kernel void CacheMeDifferently() { }'
					}
					withOptions:	self defaultCLStdOption
			).

	self
		assert:	program1 == program2.
	self
		deny:	program1 == program3.
]

{ #category : 'tests' }
ContextOpenCLRudesheimTest >> testNewCLBufferForSizeOptions [

	self
		testNewCLBufferForSizeOptions0_0.
]

{ #category : 'tests' }
ContextOpenCLRudesheimTest >> testNewCLBufferForSizeOptions0_0 [

	self
		runNewCLBufferForSizeOptions0.
]

{ #category : 'tests' }
ContextOpenCLRudesheimTest >> testNewCLBufferWithOptions [

	self
		testNewCLBufferWithOptions0_0
]

{ #category : 'tests' }
ContextOpenCLRudesheimTest >> testNewCLBufferWithOptions0_0 [

	self
		runNewCLBufferWithOptions0
]

{ #category : 'tests' }
ContextOpenCLRudesheimTest >> testNewCLCommandQueueFor [

	self
		testNewCLCommandQueueFor0_0.
]

{ #category : 'tests' }
ContextOpenCLRudesheimTest >> testNewCLCommandQueueFor0_0 [

	self
		runNewCLCommandQueueFor0.
]

{ #category : 'tests' }
ContextOpenCLRudesheimTest >> testNewCLEvent [

	self
		testNewCLEvent0_0.
]

{ #category : 'tests' }
ContextOpenCLRudesheimTest >> testNewCLEvent0_0 [

	self
		runNewCLEvent0.
]

"
A KernelOpenCLRudesheimTest is a test class for testing the behavior of KernelOpenCLRudesheim
"
Class {
	#name : 'KernelOpenCLRudesheimTest',
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
KernelOpenCLRudesheimTest class >> targetClass [

	^ KernelOpenCLRudesheim.
]

{ #category : 'accessing' }
KernelOpenCLRudesheimTest >> clContext [

	^ clContext
		ifNil:
		[
			clContext := self defaultCLContext.
		].

]

{ #category : 'accessing' }
KernelOpenCLRudesheimTest >> clContext: aContextOpenCLRudesheim [

	clContext := aContextOpenCLRudesheim.
]

{ #category : 'accessing' }
KernelOpenCLRudesheimTest >> clDevices [

	^ clDevices
		ifNil:
		[
			clDevices := self defaultCLDevices.
		].

]

{ #category : 'running' }
KernelOpenCLRudesheimTest >> tearDown [
	"testAtPut calls #tearDown/#setUp mid-method to run several testAtPut0_n
	phases in a row. #setUp (inherited) never resets clContext, so without
	this override a later phase would keep using the already-released (by
	super tearDown) native handle instead of getting a fresh one -- see
	CommandQueueOpenCLRudesheimTest>>tearDown for the same fix."

	self clContext: nil.

	super tearDown.
]

{ #category : 'accessing' }
KernelOpenCLRudesheimTest >> defaultBasicTarget [

	^ self
		trackForRelease:
		(
			self targetClass
				clKernelAt:				'Zero'
				withParameterTypes:	{ }
				of:
				(
					self
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
						)
				)
		).
]

{ #category : 'accessing' }
KernelOpenCLRudesheimTest >> defaultCLContext [

	^ self
		trackForRelease:
		(
			Rudesheim OpenCL Context
				clContextFor:	self clDevices
		).

]

{ #category : 'accessing' }
KernelOpenCLRudesheimTest >> defaultCLDevices [

	^ Rudesheim OpenCL Platform clPlatforms first clDevices.
]

{ #category : 'tests' }
KernelOpenCLRudesheimTest >> runAtPut0 [
	|
		target
	|

	target :=
		self
			trackForRelease:
			(
				self targetClass
					clKernelAt:				self sourceValue first
					withParameterTypes:	self sourceValue second
					of:
					(
						self
							trackForRelease:
							(
								self clContext
									buildCLProgramFor:	self clDevices
									fromSources:
									{
										'
kernel void One( global unsigned int *one )
{
}

kernel void Two( global unsigned int *one, unsigned int two )
{
}
										'
									}
									withOptions:	self defaultCLStdOption
							)
					)
			).

	self sourceValue last
		withIndexDo:
		[ :each :index |
			target
				at:		index 
				put:	each.
		].
]

{ #category : 'tests' }
KernelOpenCLRudesheimTest >> testAtPut [

	self
		testAtPut0_0;
		tearDown;
		setUp;
		testAtPut0_1.
]

{ #category : 'tests' }
KernelOpenCLRudesheimTest >> testAtPut0_0 [

	self
		should:
		[
			self
				sourceValue:
				{
					'One'.
					{
					}.
					{
						0
					}
				};
				runAtPut0.
		]
		raise: SubscriptOutOfBounds.
]

{ #category : 'tests' }
KernelOpenCLRudesheimTest >> testAtPut0_1 [

	self
		sourceValue:
		{
			'One'.
			{
				TFBasicType pointer
			}.
			{
				0
			}
		};
		runAtPut0.
]

{ #category : 'tests' }
KernelOpenCLRudesheimTest >> testAtPut0_2 [

	self
		sourceValue:
		{
			'One'.
			{
				TFBasicType pointer
			}.
			{
				self
					trackForRelease:
					(
						self clContext
							newCLBufferForSize:	TFBasicType uint32 byteSize
					).
			}
		};
		runAtPut0.
]

{ #category : 'tests' }
KernelOpenCLRudesheimTest >> testAtPut0_3 [

	self
		sourceValue:
		{
			'Two'.
			{
				TFBasicType pointer.
				TFBasicType uint32.
			}.
			{
				self
					trackForRelease:
					(
						self clContext
							newCLBufferForSize:	TFBasicType uint32 byteSize
					).
				1
			}
		};
		runAtPut0.
]

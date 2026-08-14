"
A KernelOpenCLRudesheimTest is a test class for testing the behavior of KernelOpenCLRudesheim
"
Class {
	#name : 'KernelOpenCLRudesheimTest',
	#superclass : 'BasicRudesheimTest',
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
KernelOpenCLRudesheimTest >> clDevices [

	^ clDevices
		ifNil:
		[
			clDevices := self defaultCLDevices.
		].

]

{ #category : 'accessing' }
KernelOpenCLRudesheimTest >> defaultBasicTarget [

	^ self targetClass
		clKernelAt:				'Zero'
		withParameterTypes:	{ }
		of:
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
				withOptions:	'-cl-std=CL2.0'
		).
]

{ #category : 'accessing' }
KernelOpenCLRudesheimTest >> defaultCLContext [

	^ Rudesheim OpenCL Context
		clContextFor:	self clDevices.


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
		self targetClass
			clKernelAt:				self sourceValue first
			withParameterTypes:	self sourceValue second
			of:
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
					withOptions:	'-cl-std=CL2.0'
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
				self clContext
					newCLBufferForSize:	TFBasicType uint32 byteSize.
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
				self clContext
					newCLBufferForSize:	TFBasicType uint32 byteSize.
				1
			}
		};
		runAtPut0.
]

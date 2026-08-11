"
A PlatformOpenCLRudesheimTest is a test class for testing the behavior of PlatformOpenCLRudesheim
"
Class {
	#name : 'PlatformOpenCLRudesheimTest',
	#superclass : 'BasicRudesheimTest',
	#category : 'Rudesheim-OpenCL-Private-Tests-Objects',
	#package : 'Rudesheim-OpenCL-Private-Tests',
	#tag : 'Objects'
}

{ #category : 'accessing' }
PlatformOpenCLRudesheimTest class >> targetClass [

	^ PlatformOpenCLRudesheim.
]

{ #category : 'tests' }
PlatformOpenCLRudesheimTest >> runCLDevices0 [
	
	self
		assert:
		[
			0 < self targetClass clPlatforms last clDevices size.
		].
]

{ #category : 'tests' }
PlatformOpenCLRudesheimTest >> runCLDevicesForType0 [
	
	self
		assert:
		[
			0 < self targetClass clPlatforms last clDevices size.
		].
]

{ #category : 'tests' }
PlatformOpenCLRudesheimTest >> runCLPlatforms0 [

	self
		assert:
		[
			0 < self targetClass clPlatforms size.
		].

]

{ #category : 'tests' }
PlatformOpenCLRudesheimTest >> testAdhoc [
	|
		cl
	|

	cl := Rudesheim OpenCL.
	self targetClass clPlatforms
		do:
		[ :each0 |
			|
				context
				devices
				program
				fill
				increment
				filled
				ouput
			|
			
			devices := each0 clDevices.
			
			context :=
				cl Context
					clContextFor:	devices.
			
			program :=
				context 
					buildCLProgramFor:	devices
					fromSources:
					{
						'
kernel void Increment( global unsigned int *input_output )
{
	++input_output[ get_global_id( 0 ) ];
}

kernel void Fill( global unsigned int *output )
{
	output[ get_global_id( 0 ) ] = get_global_id( 0 );
}
						'
					}
					withOptions:	'-cl-std=CL2.0'.

			increment :=	
				program
					newCLKernelAt: 'Increment'
					withParameterTypes:
					{
						TFBasicType pointer
					}.

			fill :=	
				program
					newCLKernelAt:	'Fill'
					withParameterTypes:
					{
						TFBasicType pointer
					}.

			ouput :=
				IntegerArray
					new: 16r10.

			filled :=
				context
					newCLBufferWith:	ouput.
			
			"event wait."
			
			devices
				do:
				[ :each1 |
					|
						queue
						event1
						event2
					|

					event1 :=
						context newCLEvent
							status: 0.
						
					queue :=
						context
							newCLCommandQueueFor: each1.

					event2 :=
						queue
							enqueueKernel: fill
							forNDRange:
							{
								{
									ouput size.
									2.
								}.
							}
							withArguments:
							{
								filled
							}
							forWait:
							{
								event1
							}.
					
					Processor yield.
					
					event2 wait.
					
					queue
						enqueueKernel: increment
						forNDRange:
						{
							{
								ouput size.
							}
						}
						withArguments:
						{
							filled
						}.

					queue
						flush;
						finish.
				].
					
			ouput inspect.
			"
			1
				to: ( 16r100 / 4 ) - 2
				do:
				[ :each |
					self
						traceCr:
						(
							'{1}'
								format:
								{
									ouput
										unsignedLongAt:	TFBasicType uint byteSize * each + 1
										bigEndian: 			false
								}
						).
				].
			"
		].

]

{ #category : 'tests' }
PlatformOpenCLRudesheimTest >> testCLDevices [

	self
		testCLDevices0_0.

]

{ #category : 'tests' }
PlatformOpenCLRudesheimTest >> testCLDevices0_0 [

	self
		runCLDevices0.

]

{ #category : 'tests' }
PlatformOpenCLRudesheimTest >> testCLDevicesForType [

	self
		testCLDevicesForType0_0.
]

{ #category : 'tests' }
PlatformOpenCLRudesheimTest >> testCLDevicesForType0_0 [
	
	self
		sourceValue:
		(
			{
				Rudesheim OpenCL All
			}
		);
		runCLDevicesForType0.
]

{ #category : 'tests' }
PlatformOpenCLRudesheimTest >> testCLPlatforms [

	self
		testCLPlatforms0_0.
]

{ #category : 'tests' }
PlatformOpenCLRudesheimTest >> testCLPlatforms0_0 [

	self
		runCLPlatforms0.
]

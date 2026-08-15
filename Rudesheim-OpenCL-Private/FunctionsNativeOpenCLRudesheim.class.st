Class {
	#name : 'FunctionsNativeOpenCLRudesheim',
	#superclass : 'Object',
	#classInstVars : [
		'tfRunner',
		'functionOfGetPlatformIDs',
		'functionOfGetDeviceIDs',
		'functionOfFlush',
		'functionOfFinish',
		'functionsOfContext',
		'functionsOfCommandQueue',
		'functionsOfProgram',
		'functionOfBuildProgram',
		'functionOfEnqueueNDRangeKernel',
		'functionsOfKernel',
		'functionsOfSetKernelArg',
		'functionsOfBuffer',
		'functionOfSetUserEventStatus',
		'functionOfWaitForEvents',
		'functionsOfEvent',
		'functionOfEnqueueCopyBuffer',
		'functionOfEnqueueFillBuffer',
		'functionsOfEnqueueMap',
		'functionOfCompileProgram',
		'functionOfLinkProgram',
		'functionOfGetProgramBuildInfo'
	],
	#category : 'Rudesheim-OpenCL-Private-Native',
	#package : 'Rudesheim-OpenCL-Private',
	#tag : 'Native'
}

{ #category : 'accessing' }
FunctionsNativeOpenCLRudesheim class >> defaultTFRunner [

	^ TFWorker
		named: 'OpenCL'.
]

{ #category : 'accessing - function' }
FunctionsNativeOpenCLRudesheim class >> functionOfBuildProgram [

	^ functionOfBuildProgram
]

{ #category : 'accessing - function' }
FunctionsNativeOpenCLRudesheim class >> functionOfCompileProgram [
	^ functionOfCompileProgram
]

{ #category : 'accessing' }
FunctionsNativeOpenCLRudesheim class >> functionOfEnqueueCopyBuffer [

	^ functionOfEnqueueCopyBuffer
]

{ #category : 'accessing' }
FunctionsNativeOpenCLRudesheim class >> functionOfEnqueueFillBuffer [

	^ functionOfEnqueueFillBuffer
]

{ #category : 'accessing - function' }
FunctionsNativeOpenCLRudesheim class >> functionOfEnqueueNDRangeKernel [

	^ functionOfEnqueueNDRangeKernel
]

{ #category : 'accessing - function' }
FunctionsNativeOpenCLRudesheim class >> functionOfFinish [

	^ functionOfFinish
]

{ #category : 'accessing - function' }
FunctionsNativeOpenCLRudesheim class >> functionOfFlush [

	^ functionOfFlush
]

{ #category : 'accessing - function' }
FunctionsNativeOpenCLRudesheim class >> functionOfGetDeviceIDs [

	^ functionOfGetDeviceIDs
]

{ #category : 'accessing - function' }
FunctionsNativeOpenCLRudesheim class >> functionOfGetPlatformIDs [

	^ functionOfGetPlatformIDs
]

{ #category : 'accessing - function' }
FunctionsNativeOpenCLRudesheim class >> functionOfGetProgramBuildInfo [
	^ functionOfGetProgramBuildInfo
]

{ #category : 'accessing - function' }
FunctionsNativeOpenCLRudesheim class >> functionOfLinkProgram [
	^ functionOfLinkProgram
]

{ #category : 'accessing - function' }
FunctionsNativeOpenCLRudesheim class >> functionOfSetUserEventStatus [

	^ functionOfSetUserEventStatus
]

{ #category : 'accessing - function' }
FunctionsNativeOpenCLRudesheim class >> functionOfWaitForEvents [

	^ functionOfWaitForEvents
]

{ #category : 'accessing - function' }
FunctionsNativeOpenCLRudesheim class >> functionsOfBuffer [

	^ functionsOfBuffer
]

{ #category : 'accessing - function' }
FunctionsNativeOpenCLRudesheim class >> functionsOfCommandQueue [

	^ functionsOfCommandQueue
]

{ #category : 'accessing - function' }
FunctionsNativeOpenCLRudesheim class >> functionsOfContext [

	^ functionsOfContext
]

{ #category : 'accessing' }
FunctionsNativeOpenCLRudesheim class >> functionsOfEnqueueMap [

	^ functionsOfEnqueueMap
]

{ #category : 'accessing' }
FunctionsNativeOpenCLRudesheim class >> functionsOfEvent [

	^ functionsOfEvent
]

{ #category : 'accessing - function' }
FunctionsNativeOpenCLRudesheim class >> functionsOfKernel [

	^ functionsOfKernel
]

{ #category : 'accessing - function' }
FunctionsNativeOpenCLRudesheim class >> functionsOfProgram [

	^ functionsOfProgram
]

{ #category : 'accessing - function' }
FunctionsNativeOpenCLRudesheim class >> functionsOfSetKernelArg [

	^ functionsOfSetKernelArg
]

{ #category : 'class initialization' }
FunctionsNativeOpenCLRudesheim class >> initialize [
	|
		moduleName
		pointer
		uint64
		uint32
		sint32
		uint8
		sizeT
	|

	moduleName := LibraryNativeOpenCLRudesheim uniqueInstance libraryName.

	pointer := TFBasicType pointer.
	uint64 := TFBasicType uint64.
	uint32 := TFBasicType uint32.
	sint32 := TFBasicType sint32.
	uint8 := TFBasicType uint8.
	sizeT :=TFBasicType sizeT.

	functionOfGetPlatformIDs :=
		TFExternalFunction
			name:		'clGetPlatformIDs'
			moduleName: moduleName
			definition:
			(
				TFFunctionDefinition
					parameterTypes:
					{
						uint32.
						pointer.
						pointer.
					}
					returnType: sint32
			).

	functionOfGetDeviceIDs :=
		TFExternalFunction
			name:		'clGetDeviceIDs'
			moduleName: moduleName
			definition:
			(
				TFFunctionDefinition
					parameterTypes:
					{
						pointer.
						uint64.
						uint32.
						pointer.
						pointer.
					}
					returnType: sint32
			).

	functionsOfContext :=
	{
		TFExternalFunction
			name:		'clReleaseContext'
			moduleName: moduleName
			definition:
			(
				TFFunctionDefinition
					parameterTypes:
					{
						pointer.
					}
					returnType: sint32
			).

		TFExternalFunction
			name:		'clCreateContext'
			moduleName: moduleName
			definition:
			(
				TFFunctionDefinition
					parameterTypes:
					{
						pointer.
						uint32.
						pointer.
						pointer.
						pointer.
						pointer.
					}
					returnType: pointer
			).
	}.

	functionsOfProgram :=
	{
		TFExternalFunction
			name:		'clReleaseProgram'
			moduleName: moduleName
			definition:
			(
				TFFunctionDefinition
					parameterTypes:
					{
						pointer.
					}
					returnType: sint32
			).

		TFExternalFunction
			name:		'clCreateProgramWithSource'
			moduleName: moduleName
			definition:
			(
				TFFunctionDefinition
					parameterTypes:
					{
						pointer.
						uint32.
						pointer.
						pointer.
						pointer.
					}
					returnType: pointer
			).
	}.

	functionOfBuildProgram :=
		TFExternalFunction
			name:		'clBuildProgram'
			moduleName: moduleName
			definition:
			(
				TFFunctionDefinition
					parameterTypes:
					{
						pointer.
						uint32.
						pointer.
						pointer.
						pointer.
						pointer.
					}
					returnType: sint32
			).

	functionOfCompileProgram :=
		TFExternalFunction
			name:		'clCompileProgram'
			moduleName: moduleName
			definition:
			(
				TFFunctionDefinition
					parameterTypes:
					{
						pointer.
						uint32.
						pointer.
						pointer.
						uint32.
						pointer.
						pointer.
						pointer.
						pointer.
					}
					returnType: sint32
			).

	functionOfLinkProgram :=
		TFExternalFunction
			name:		'clLinkProgram'
			moduleName: moduleName
			definition:
			(
				TFFunctionDefinition
					parameterTypes:
					{
						pointer.
						uint32.
						pointer.
						pointer.
						uint32.
						pointer.
						pointer.
						pointer.
						pointer.
					}
					returnType: pointer
			).

	functionOfGetProgramBuildInfo :=
		TFExternalFunction
			name:		'clGetProgramBuildInfo'
			moduleName: moduleName
			definition:
			(
				TFFunctionDefinition
					parameterTypes:
					{
						pointer.
						pointer.
						uint32.
						sizeT.
						pointer.
						pointer.
					}
					returnType: sint32
			).

	functionsOfBuffer :=
	{
		TFExternalFunction
			name:		'clReleaseMemObject'
			moduleName: moduleName
			definition:
			(
				TFFunctionDefinition
					parameterTypes:
					{
						pointer.
					}
					returnType: sint32
			).

		TFExternalFunction
			name:		'clCreateBuffer'
			moduleName: moduleName
			definition:
			(
				TFFunctionDefinition
					parameterTypes:
					{
						pointer.
						uint64.
						sizeT.
						pointer.
						pointer.
					}
					returnType: pointer
			).
	}.

	functionsOfKernel :=
	{
		TFExternalFunction
			name:		'clReleaseKernel'
			moduleName: moduleName
			definition:
			(
				TFFunctionDefinition
					parameterTypes:
					{
						pointer.
					}
					returnType: sint32
			).

		TFExternalFunction
			name:		'clCreateKernel'
			moduleName: moduleName
			definition:
			(
				TFFunctionDefinition
					parameterTypes:
					{
						pointer.
						pointer.
						pointer.
					}
					returnType: pointer
			).
	}.

	functionsOfSetKernelArg :=
		TFExternalFunction
			name:		'clSetKernelArg'
			moduleName: moduleName
			definition:
			(
				TFFunctionDefinition
					parameterTypes:
					{
						pointer.
						uint32.
						sizeT.
						pointer.
					}
					returnType: sint32
			).

	functionsOfCommandQueue :=
	{
		TFExternalFunction
			name:		'clReleaseCommandQueue'
			moduleName: moduleName
			definition:
			(
				TFFunctionDefinition
					parameterTypes:
					{
						pointer.
					}
					returnType: sint32
			).

		TFExternalFunction
			name:		'clCreateCommandQueue'
			moduleName: moduleName
			definition:
			(
				TFFunctionDefinition
					parameterTypes:
					{
						pointer.
						pointer.
						pointer.
						pointer.
					}
					returnType: pointer
			).
	}.

	functionOfFlush :=
		TFExternalFunction
			name:		'clFlush'
			moduleName: moduleName
			definition:
			(
				TFFunctionDefinition
					parameterTypes:
					{
						pointer.
					}
					returnType: sint32
			).

	functionOfFinish :=
		TFExternalFunction
			name:		'clFinish'
			moduleName: moduleName
			definition:
			(
				TFFunctionDefinition
					parameterTypes:
					{
						pointer.
					}
					returnType: sint32
			).

	functionOfEnqueueNDRangeKernel :=
		TFExternalFunction
			name:		'clEnqueueNDRangeKernel'
			moduleName: moduleName
			definition:
			(
				TFFunctionDefinition
					parameterTypes:
					{
						pointer.
						pointer.
						uint32.
						pointer.
						pointer.
						pointer.
						uint32.
						pointer.
						pointer.
					}
					returnType: sint32
			).

	functionOfEnqueueCopyBuffer :=
		TFExternalFunction
			name:		'clEnqueueCopyBuffer'
			moduleName: moduleName
			definition:
			(
				TFFunctionDefinition
					parameterTypes:
					{
						pointer.
						pointer.
						pointer.
						sizeT.
						sizeT.
						sizeT.
						uint32.
						pointer.
						pointer.
					}
					returnType: sint32
			).

	functionOfEnqueueFillBuffer :=
		TFExternalFunction
			name:		'clEnqueueFillBuffer'
			moduleName: moduleName
			definition:
			(
				TFFunctionDefinition
					parameterTypes:
					{
						pointer.
						pointer.
						pointer.
						sizeT.
						sizeT.
						sizeT.
						uint32.
						pointer.
						pointer.
					}
					returnType: sint32
			).

	functionsOfEnqueueMap :=
	{
		TFExternalFunction
			name:		'clEnqueueMapBuffer'
			moduleName: moduleName
			definition:
			(
				TFFunctionDefinition
					parameterTypes:
					{
						pointer.
						pointer.
						uint8.
						uint64.
						sizeT.
						sizeT.
						uint32.
						pointer.
						pointer.
						pointer.
					}
					returnType: pointer
			).
		TFExternalFunction
			name:		'clEnqueueUnmapMemObject'
			moduleName: moduleName
			definition:
			(
				TFFunctionDefinition
					parameterTypes:
					{
						pointer.
						pointer.
						pointer.
						uint32.
						pointer.
						pointer.
					}
					returnType: sint32
			).
	}.

	functionsOfEvent :=
	{
		TFExternalFunction
			name:		'clReleaseEvent'
			moduleName: moduleName
			definition:
			(
				TFFunctionDefinition
					parameterTypes:
					{
						pointer.
					}
					returnType: sint32
			).

		TFExternalFunction
			name:		'clCreateUserEvent'
			moduleName: moduleName
			definition:
			(
				TFFunctionDefinition
					parameterTypes:
					{
						pointer.
						pointer.
					}
					returnType: pointer
			).
	}.

	functionOfSetUserEventStatus :=
		TFExternalFunction
			name:		'clSetUserEventStatus'
			moduleName: moduleName
			definition:
			(
				TFFunctionDefinition
					parameterTypes:
					{
						pointer.
						sint32.
					}
					returnType: sint32
			).

	functionOfWaitForEvents :=
		TFExternalFunction
			name:		'clWaitForEvents'
			moduleName: moduleName
			definition:
			(
				TFFunctionDefinition
					parameterTypes:
					{
						uint32.
						pointer.
					}
					returnType: sint32
			).
]

{ #category : 'accessing' }
FunctionsNativeOpenCLRudesheim class >> tfRunner [

	^ tfRunner
		ifNil:
		[
			tfRunner := self defaultTFRunner.
		].
]

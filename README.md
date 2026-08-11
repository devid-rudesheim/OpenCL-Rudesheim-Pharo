# Rudesheim OpenCL for Pharo

Rudesheim OpenCL is a Pharo wrapper around OpenCL used by Rudesheim projects that need GPU or accelerator execution.
It provides platforms, devices, contexts, command queues, programs, kernels, buffers, events, and OpenCL error objects.
The package is a low-level execution layer: higher-level packages can keep their domain code in Smalltalk while sending data-parallel kernels to an OpenCL device.

## Installation

Load the default project group with Metacello:

```smalltalk
Metacello new
	baseline: 'RudesheimOpenCL';
	repository: 'github://devid-rudesheim/OpenCL-Rudesheim-Pharo:main';
	load
```

This also loads the required `RudesheimKernel` and `RudesheimUtility` dependencies from GitHub.

## Groups

- `core`: runtime OpenCL packages.
- `tests`: SUnit tests for the OpenCL packages.
- `default`: aliases `core`.

To load the tests:

```smalltalk
Metacello new
	baseline: 'RudesheimOpenCL';
	repository: 'github://devid-rudesheim/OpenCL-Rudesheim-Pharo:main';
	load: #(tests)
```

## Basic Use

```smalltalk
cl := Rudesheim OpenCL.
devices := cl Platform clPlatforms first clDevices.
context := cl Context clContextFor: devices.
queue := cl CommandQueue clCommandQueueFor: devices first of: context.

program :=
	context
		buildCLProgramFor: devices
		fromSources:
		{
'
kernel void ScaleByTwo( global const float* input, global float* output )
{
	size_t index;

	index = get_global_id(0);
	output[ index ] = input[ index ] * 2.0f;
}
'
		}
		withOptions: '-cl-std=CL2.0'.

kernel :=
	program
		newCLKernelAt: 'ScaleByTwo'
		withParameterTypes:
		{
			TFBasicType pointer.
			TFBasicType pointer.
		}.

inputBuffer := context newCLBufferWithFloats: #( 1.5 2.5 3.5 4.5 ).
outputBuffer := context newCLBufferForSize: 4 * TFBasicType float byteSize.

queue
	enqueueKernelAndWait: kernel
	forNDRange:
	{
		{ 4. 1. 1. }
	}
	withArguments:
	{
		inputBuffer.
		outputBuffer.
	}.

queue
	readFloatsFrom: outputBuffer
	count: 4
```

The result is `#( 3.0 5.0 7.0 9.0 )`.
OpenCL behavior depends on the host system, drivers, and available devices.

## Run Tests

After loading the test group, run:

```smalltalk
TestSuite new
	addTest: (RPackageOrganizer default packageNamed: 'Rudesheim-OpenCL-Tests') asTestSuite;
	addTest: (RPackageOrganizer default packageNamed: 'Rudesheim-OpenCL-Private-Tests') asTestSuite;
	run
```

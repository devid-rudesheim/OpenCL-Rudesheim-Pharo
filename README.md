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

## Requirements

- Pharo with FFI support.
- A native OpenCL runtime visible to the host process.
- At least one OpenCL platform/device for code that creates contexts, command queues, buffers, programs, or kernels.

On macOS, the package avoids OpenCL separate compile/link calls because the native implementation is not reliable there.
Build complete programs from source with `buildCLProgramFor:fromSources:withOptions:` as shown below.

## Dependencies

The baseline loads these Rudesheim repositories:

- `RudesheimKernel`: `github://devid-rudesheim/Kernel-Rudesheim-Pharo:main`
- `RudesheimUtility`: `github://devid-rudesheim/Utility-Rudesheim-Pharo:main`

## Groups

- `core`: runtime OpenCL packages.
- `tests`: SUnit tests for the OpenCL packages.
- `default`: aliases `core`.

## Load Options

Default runtime load:

```smalltalk
Metacello new
	baseline: 'RudesheimOpenCL';
	repository: 'github://devid-rudesheim/OpenCL-Rudesheim-Pharo:main';
	load
```

Tests:

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

## Usage Constraints

- Kernel source is OpenCL C. Function names and argument order must match the `newCLKernelAt:withParameterTypes:` declaration.
- Buffer sizes and `TFBasicType` argument declarations are caller responsibility.
- Long-running code should release native-backed objects such as buffers, command queues, programs, kernels, and events when ownership is clear.
- `buildCLProgramFor:fromSources:withOptions:` is the normal source-build path. Separate compile/link is intentionally not the portable path on macOS.
- Test execution requires a working OpenCL device; failures can be driver/platform specific.

## Run Tests

After loading the test group, run:

```smalltalk
TestSuite new
	addTest: (RPackageOrganizer default packageNamed: 'Rudesheim-OpenCL-Tests') asTestSuite;
	addTest: (RPackageOrganizer default packageNamed: 'Rudesheim-OpenCL-Private-Tests') asTestSuite;
	run
```

# Rudesheim OpenCL for Pharo

[![GitHub release](https://img.shields.io/github/release/devid-rudesheim/OpenCL-Rudesheim-Pharo.svg)](https://github.com/devid-rudesheim/OpenCL-Rudesheim-Pharo/releases/latest)
[![Unit Tests](https://github.com/devid-rudesheim/OpenCL-Rudesheim-Pharo/actions/workflows/tests.yml/badge.svg)](https://github.com/devid-rudesheim/OpenCL-Rudesheim-Pharo/actions/workflows/tests.yml)

[![Pharo 13](https://img.shields.io/badge/Pharo-13-informational)](https://pharo.org)

> **CI status:** the Unit Tests workflow installs `pocl` (a CPU-based OpenCL implementation) as the ICD before running the suite on the Ubuntu runner. The `clGetDeviceIDs`/`clGetPlatformIDs` segfault previously reported here was **not** a `pocl`/threaded-FFI-worker incompatibility as first suspected — it was a bug in this package's own ID-array readback code (`IDNativeOpenCLRudesheim class>>onDo:`): the native call writes an array of pointer-sized (8-byte) IDs, but the Smalltalk side read them back as 4-byte `uint32` values at the wrong byte offset, silently truncating every ID to its lower 32 bits. With exactly one platform/device (as under `pocl`), the first element's offset happened to be correct, so `clGetPlatformIDs` looked fine while the truncated pointer it produced then crashed the very next `clGetDeviceIDs` call inside the ICD loader. Fixed by reading each ID as a full pointer-sized value at the correct stride. Verified against `pocl` in a Podman container (Ubuntu 24.04, amd64) and against a real GPU/vendor OpenCL runtime on macOS (cl2Metal) — both pass with no crash. Once that crash was out of the way, most remaining test failures under `pocl` turned out to be a second, unrelated issue: the test suite built every kernel with `-cl-std=CL2.0`, which `pocl`'s CPU device rejects outright ("Build option -cl-std specified OpenCL C version 2.0, but device cpu doesn't support that OpenCL C version"), even though none of the test kernels use any OpenCL C 2.0-specific language feature. `-cl-std=CL3.0` builds successfully on both `pocl` and a real GPU/vendor runtime (macOS cl2Metal), so the test suite now targets CL3.0 via a single shared `BasicOpenCLRudesheimTest>>defaultCLStdOption` accessor instead of a literal repeated across every test. Locally the suite passes against a real GPU/vendor OpenCL runtime (182 Tests, 0 Failures, 0 Errors).

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
- `default`: aliases `core`.

## Load Options

Default runtime load:

```smalltalk
Metacello new
	baseline: 'RudesheimOpenCL';
	repository: 'github://devid-rudesheim/OpenCL-Rudesheim-Pharo:main';
	load
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
		withOptions: '-cl-std=CL3.0'.

kernel :=
	program
		newCLKernelAt: 'ScaleByTwo'
		withParameterTypes:
		{
			TFBasicType pointer.
			TFBasicType pointer.
		}.

inputBuffer := context newCLBufferWith: #( 1.5 2.5 3.5 4.5 ) elementType: TFBasicType float.
outputBuffer := context newCLBufferForElementCount: 4 elementType: TFBasicType float.

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
	readFrom: outputBuffer
	count: 4
	elementType: TFBasicType float
```

The result is `#( 3.0 5.0 7.0 9.0 )`.
OpenCL behavior depends on the host system, drivers, and available devices.

## Usage Constraints

- Kernel source is OpenCL C. Function names and argument order must match the `newCLKernelAt:withParameterTypes:` declaration.
- Buffer sizes and `TFBasicType` argument declarations are caller responsibility.
- Long-running code should release native-backed objects such as buffers, command queues, programs, kernels, and events when ownership is clear.
- `buildCLProgramFor:fromSources:withOptions:` is the normal source-build path. Separate compile/link is intentionally not the portable path on macOS.

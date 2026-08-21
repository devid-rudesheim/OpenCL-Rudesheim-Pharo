# Rudesheim OpenCL for Pharo

[![GitHub release](https://img.shields.io/github/release/devid-rudesheim/OpenCL-Rudesheim-Pharo.svg)](https://github.com/devid-rudesheim/OpenCL-Rudesheim-Pharo/releases/latest)
[![Unit Tests](https://github.com/devid-rudesheim/OpenCL-Rudesheim-Pharo/actions/workflows/tests.yml/badge.svg)](https://github.com/devid-rudesheim/OpenCL-Rudesheim-Pharo/actions/workflows/tests.yml)

[![Pharo 13](https://img.shields.io/badge/Pharo-13-informational)](https://pharo.org)

> **Note:** OpenCL behavior can vary across ICD/runtime implementations (e.g. `pocl`'s CPU device vs. vendor GPU drivers) — differences in ID/pointer width and supported `-cl-std` versions have caused platform-specific bugs here before. Kernels are built with `-cl-std=CL3.0` for portability across `pocl` and vendor GPU runtimes (see `BasicOpenCLRudesheimTest>>defaultCLStdOption`).

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

The outer `forNDRange:` array mirrors the three optional NDRange pointers passed to `clEnqueueNDRangeKernel`, in this order:

```smalltalk
{
	globalWorkSize.
	localWorkSize.
	globalWorkOffset.
}
```

Only `globalWorkSize` is required, so `forNDRange: { { 4. 1. 1. } }` launches a three-dimensional NDRange with global size `4 x 1 x 1`, while leaving local size and global offset unspecified. To choose a local work-group size, include the second entry, for example `forNDRange: { { 1024 }. { 64 } }`. To also set the offset, include the third entry, for example `forNDRange: { { 1024 }. { 64 }. { 0 } }`.

## Selecting a Device Type

`clDevices` returns every device on a platform. To target a specific kind of device (GPU, CPU, accelerator), use `clDevicesForType:` with one of the `Rudesheim OpenCL` device-type markers:

```smalltalk
cl := Rudesheim OpenCL.
platform := cl Platform clPlatforms first.

gpuDevices := platform clDevicesForType: { cl Gpu }.
cpuDevices := platform clDevicesForType: { cl Cpu }.
anyDevice  := platform clDevicesForType: { cl Default }.
```

`Gpu`, `Cpu`, `Accelerator`, `Default`, `Custom`, and `All` are all available. `clDevicesForType:` takes a collection so multiple types can be requested at once (e.g. `{ cl Gpu. cl Cpu }`).

## Buffer Element Types

`newCLBufferWith:elementType:` and `newCLBufferForElementCount:elementType:` work with any of the `TFBasicType` numeric kinds Rudesheim OpenCL supports — the element type decides both the buffer's byte size and how each element is marshalled, so the same two selectors cover every case:

```smalltalk
floatBuffer  := context newCLBufferWith: #( 1.5 2.5 3.5 )     elementType: TFBasicType float.
doubleBuffer := context newCLBufferWith: #( 1.25 2.75 )       elementType: TFBasicType double.
uint8Buffer  := context newCLBufferWith: #( 1 2 255 )         elementType: TFBasicType uint8.
sint32Buffer := context newCLBufferWith: #( 1 -2 3 )          elementType: TFBasicType sint32.

"An empty buffer sized from element count instead of content to upload:"
emptyUint16Buffer := context newCLBufferForElementCount: 8 elementType: TFBasicType uint16.
```

`float`, `double`, `uint8`/`16`/`32`/`64`, and `sint8`/`16`/`32`/`64` are all supported. Passing an unsupported `TFBasicType` (e.g. `TFBasicType pointer`) raises `ElementTypeNotSupportedOpenCLRudesheim`.

## Downloading Buffer Content

`readFrom:count:elementType:` is the counterpart to `newCLBufferWith:elementType:` — pass the same element type used to create the buffer:

```smalltalk
result := queue readFrom: uint8Buffer count: 3 elementType: TFBasicType uint8.
"result = #( 1 2 255 )"
```

A buffer created with `asOpenCLBufferRudesheim:` or read back via `BufferOpenCLRudesheim>>asArray` is always treated as `TFBasicType float`, since a bare `BufferOpenCLRudesheim` does not carry its own element type.

## Mapping a Buffer for Direct Host Access

Uploading via `newCLBufferWith:elementType:` copies host data in. For writing (or reading) a buffer's memory directly without a separate upload/download step, map it instead — `enqueueMap:forRange:as:options:blocking:forWait:` returns `{ hostPointer. mapEvent }`, and the returned pointer understands the same `AtOffset:put:` primitives a `ByteArray` does:

```smalltalk
buffer := context newCLBufferForElementCount: 4 elementType: TFBasicType float.

mapped := queue
	enqueueMap: buffer
	forRange: (1 to: 4)
	as: TFBasicType float
	options: { Rudesheim OpenCL WriteOnly }
	blocking: true
	forWait: {}.
pointer := mapped first.

"Any Rudesheim OpenCL ElementType class can write directly into the mapped pointer:"
TFBasicType float openCLElementTypeRudesheim
	writeElementsOf: #( 1.5 2.5 3.5 4.5 )
	intoByteArray: pointer.

(queue enqueueUnmap: pointer of: buffer forWait: { mapped last }) wait.
mapped last release.
```

There's also a block-based convenience form, `enqueueMap:forRange:as:options:blocking:forWait:do:`, that maps, runs the block with the pointer, and enqueues the matching unmap automatically — it returns the unmap `Event` rather than the block's result.

## Events, Return-Value Waiting, and Chaining Enqueues

Every `enqueue*` selector that isn't the `...AndWait:` convenience form returns a fresh `Event` for the operation it just queued, and every `enqueue*` selector also takes a `forWait:` collection of `Event`s the operation must wait on before it starts. `enqueueKernelAndWait:forNDRange:withArguments:` is built from exactly these two pieces:

```smalltalk
event := queue
	enqueueKernel: kernel
	forNDRange: { { 4. 1. 1. } }
	withArguments: { inputBuffer. outputBuffer }
	forWait: {}.
event wait.
event release.
```

The returned `Event` is the hook for chaining: pass one operation's `Event` into the next operation's `forWait:` and the *driver* serializes them on the device — the host never blocks in between. Only the final result actually needs a host-side `wait`:

```smalltalk
"input -> mid (kernel A), then mid -> output (kernel B), chained on the device:"
firstEvent := queue
	enqueueKernel: kernel
	forNDRange: { { 4. 1. 1. } }
	withArguments: { inputBuffer. midBuffer }
	forWait: {}.

secondEvent := queue
	enqueueKernel: kernel
	forNDRange: { { 4. 1. 1. } }
	withArguments: { midBuffer. outputBuffer }
	forWait: { firstEvent }.

"Only secondEvent needs waiting on -- the host was never blocked between A and B:"
secondEvent wait.
firstEvent release.
secondEvent release.

result := queue readFrom: outputBuffer count: 4 elementType: TFBasicType float.
"input #( 1.0 2.0 3.0 4.0 ) scaled by 2 twice -> result = #( 4.0 8.0 12.0 16.0 )"
```

Any mix of `enqueueKernel:...`, `enqueueCopyFrom:...`, and `enqueueMap:...`/`enqueueUnmap:...` can be chained the same way, since they all share this returns-an-Event/takes-a-forWait:-collection shape (`BufferOpenCLRudesheim>>rudesheimConcatenatedWith:` is a good example already in this codebase, chaining two `enqueueCopyFrom:` calls into one merged buffer).

`newCLEvent` creates a separate, user-triggered `Event` not tied to any enqueue — useful for gating a batch of enqueued work on some external condition:

```smalltalk
gate := context newCLEvent.

queue
	enqueueKernel: kernel
	forNDRange: { { 4. 1. 1. } }
	withArguments: { inputBuffer. outputBuffer }
	forWait: { gate }.

"...later, once whatever the kernel should wait for is ready:"
gate status: 0.

queue finish.
gate release.
```

## Releasing Resources

`release` is available on buffers, command queues, programs, kernels, contexts, and events — every one of them is a `HandleNativeOpenCLRudesheim` subclass, and all of them register with Pharo's `FFIExternalResourceManager` at creation time, so an unreleased instance *does* eventually get its native handle cleaned up when the Smalltalk object is garbage collected. That auto-release is a safety net, not a substitute for calling `release` promptly: the GC finalizer that drives it doesn't run between iterations of a tight loop, so code that creates many buffers/events without releasing them can exhaust the native external-object table before the finalizer ever gets a chance to run (`Error: Not enough space for external objects`). Release explicitly once ownership is clear, same as any other native-backed resource — see `Usage Constraints` below.

**Don't rely on the finalizer for anything beyond that safety net, either.** In a short-lived headless process the image exits before finalization ever runs, so leftover unreleased handles are harmless in practice. In a long-lived interactive session (the Pharo IDE open in a window, a System Browser "Run test"), finalization *does* eventually run — and when many handles become unreachable around the same time, the resulting burst of `clRelease*` calls has been observed to race with the macOS OpenCL implementation's Metal-backed bridge (`cl2Metal`) and crash the VM natively (SIGSEGV inside `clCreateCommandQueueWithPropertiesAPPLE`/`clFinish`/`clReleaseContext`, on the `TFWorker` thread issuing the call). `Rudesheim-OpenCL-Private-Tests` fixes this by tracking every native handle it creates and releasing them all deterministically in `tearDown` (`BasicOpenCLRudesheimTest>>trackForRelease:`) instead of leaving it to GC — follow that pattern (explicit release on a known lifecycle boundary, not "eventually, whenever GC gets to it") for any code that creates OpenCL objects in a process that stays alive for a while.

## Usage Constraints

- Kernel source is OpenCL C. Function names and argument order must match the `newCLKernelAt:withParameterTypes:` declaration.
- Buffer sizes and `TFBasicType` argument declarations are caller responsibility.
- Long-running code should release native-backed objects such as buffers, command queues, programs, kernels, and events when ownership is clear.
- `buildCLProgramFor:fromSources:withOptions:` is the normal source-build path. Separate compile/link is intentionally not the portable path on macOS.
- **On macOS, don't force-kill a process that's holding live OpenCL/GPU resources.** Killing a Pharo process with `SIGKILL` while it still has an open OpenCL context/command queue skips the native `clRelease*` cleanup entirely. Doing this repeatedly (e.g. while debugging a crash/hang) has been observed to leave the machine's GPU/OpenCL driver state degraded system-wide — later Pharo processes, even a fresh one with none of the previous process's objects, can then crash or hang inside Apple's OpenCL.framework (e.g. a deadlock inside `AppleMetalOpenGLRenderer`'s `GLDShareGroupRec::waitUsage`) for reasons that have nothing to do with this package's code. If OpenCL-related crashes/hangs stop reproducing in a fresh image but keep happening on a machine that's had several such force-kills, **reboot the machine** before concluding there's a real bug — a reboot resolved exactly this situation during the investigation that produced the fix described above. Prefer letting a stuck process terminate itself (or `SIGTERM` with a grace period) over an immediate `SIGKILL` when it's holding OpenCL resources.

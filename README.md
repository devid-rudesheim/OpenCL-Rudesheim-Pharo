# Rudesheim OpenCL for Pharo

Rudesheim OpenCL is a Pharo wrapper around OpenCL used by Rudesheim projects that need GPU or accelerator execution.
It provides platforms, devices, contexts, command queues, programs, kernels, buffers, events, and OpenCL error objects.

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
opencl := Rudesheim OpenCL.
platforms := opencl platforms.
devices := platforms first devices.
```

OpenCL behavior depends on the host system, drivers, and available devices.

## Run Tests

After loading the test group, run:

```smalltalk
TestSuite new
	addTest: (RPackageOrganizer default packageNamed: 'Rudesheim-OpenCL-Tests') asTestSuite;
	addTest: (RPackageOrganizer default packageNamed: 'Rudesheim-OpenCL-Private-Tests') asTestSuite;
	run
```

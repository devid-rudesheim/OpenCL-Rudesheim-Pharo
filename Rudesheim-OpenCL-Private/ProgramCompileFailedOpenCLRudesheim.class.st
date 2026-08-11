"
A ProgramCompileFailedOpenCLRudesheim is raised when clCompileProgram fails for a ProgramOpenCLRudesheim.

Carries the program, target devices, compile options, header associations, and the build log fetched via ProgramOpenCLRudesheim>>buildLogFor: at the moment of failure.

Note: on this development machine, clCompileProgram itself has been observed to crash the native OpenCL implementation (a platform/driver limitation, not a bug in this class) even for a trivial, valid kernel with no headers. The compile/link two-stage API (ProgramOpenCLRudesheim class>>compileCLProgramFor:fromSources:withOptions:headers:of: / clProgramByLinking:for:withOptions:of:) is implemented but unverified end-to-end here; it may work correctly on other OpenCL implementations (e.g. POCL on Linux).
"
Class {
	#name : 'ProgramCompileFailedOpenCLRudesheim',
	#superclass : 'DetailedPrimitiveErrorNativeOpenCLRudesheim',
	#instVars : [
		'program',
		'devices',
		'options',
		'headers',
		'buildLog'
	],
	#category : 'Rudesheim-OpenCL-Private-Errors-Program',
	#package : 'Rudesheim-OpenCL-Private',
	#tag : 'Errors-Program'
}

{ #category : 'instance creation' }
ProgramCompileFailedOpenCLRudesheim class >> signalForCause:	aPrimitiveErrorNativeOpenCLRudesheim
program:		aProgramOpenCLRudesheim
devices:		aCLDevicesCollection
options:		anOptionsString
headers:		aHeaderAssociationsCollection
buildLog:		aBuildLogString [

	^ self basicNew
		signalForCause:	aPrimitiveErrorNativeOpenCLRudesheim
		program:		aProgramOpenCLRudesheim
		devices:		aCLDevicesCollection
		options:		anOptionsString
		headers:		aHeaderAssociationsCollection
		buildLog:		aBuildLogString.
]

{ #category : 'accessing' }
ProgramCompileFailedOpenCLRudesheim >> buildLog [
	^ buildLog.
]

{ #category : 'accessing' }
ProgramCompileFailedOpenCLRudesheim >> buildLog: aBuildLogString [
	buildLog := aBuildLogString.
]

{ #category : 'accessing' }
ProgramCompileFailedOpenCLRudesheim >> contextDescription [
	^ 'compiling ', self program printString, ' for devices ', self devices printString, ' with options ''', self options, '''', ' and headers ', self headers printString, ' - build log: ', self buildLog.
]

{ #category : 'accessing' }
ProgramCompileFailedOpenCLRudesheim >> devices [
	^ devices.
]

{ #category : 'accessing' }
ProgramCompileFailedOpenCLRudesheim >> devices: aCLDevicesCollection [
	devices := aCLDevicesCollection.
]

{ #category : 'accessing' }
ProgramCompileFailedOpenCLRudesheim >> headers [
	^ headers.
]

{ #category : 'accessing' }
ProgramCompileFailedOpenCLRudesheim >> headers: aHeaderAssociationsCollection [
	headers := aHeaderAssociationsCollection.
]

{ #category : 'accessing' }
ProgramCompileFailedOpenCLRudesheim >> options [
	^ options.
]

{ #category : 'accessing' }
ProgramCompileFailedOpenCLRudesheim >> options: anOptionsString [
	options := anOptionsString.
]

{ #category : 'accessing' }
ProgramCompileFailedOpenCLRudesheim >> program [
	^ program.
]

{ #category : 'accessing' }
ProgramCompileFailedOpenCLRudesheim >> program: aProgramOpenCLRudesheim [
	program := aProgramOpenCLRudesheim.
]

{ #category : 'signaling' }
ProgramCompileFailedOpenCLRudesheim >> signalForCause:	aPrimitiveErrorNativeOpenCLRudesheim
program:		aProgramOpenCLRudesheim
devices:		aCLDevicesCollection
options:		anOptionsString
headers:		aHeaderAssociationsCollection
buildLog:		aBuildLogString [

	self
		cause:		aPrimitiveErrorNativeOpenCLRudesheim;
		program:	aProgramOpenCLRudesheim;
		devices:	aCLDevicesCollection;
		options:	anOptionsString;
		headers:	aHeaderAssociationsCollection;
		buildLog:	aBuildLogString.

	^ super signal.
]

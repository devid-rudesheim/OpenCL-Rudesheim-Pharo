"
A ProgramLinkFailedOpenCLRudesheim is raised when clLinkProgram fails while linking a collection of ProgramOpenCLRudesheim objects into a new one.

Carries the context, target devices, the input programs being linked, the link options, and a build log field (usually a fixed unavailable-message string, since clLinkProgram typically returns no program object to query a log from on failure).

See ProgramCompileFailedOpenCLRudesheim's class comment for a caveat about clCompileProgram/clLinkProgram being unverified on this development machine due to an apparent platform/driver crash.
"
Class {
	#name : 'ProgramLinkFailedOpenCLRudesheim',
	#superclass : 'DetailedPrimitiveErrorNativeOpenCLRudesheim',
	#instVars : [
		'context',
		'devices',
		'programs',
		'options',
		'buildLog'
	],
	#category : 'Rudesheim-OpenCL-Private-Errors-Program',
	#package : 'Rudesheim-OpenCL-Private',
	#tag : 'Errors-Program'
}

{ #category : 'instance creation' }
ProgramLinkFailedOpenCLRudesheim class >> signalForCause:	aPrimitiveErrorNativeOpenCLRudesheim
context:		aCLContext
devices:		aCLDevicesCollection
programs:		aProgramsCollection
options:		anOptionsString
buildLog:		aBuildLogString [

	^ self basicNew
		signalForCause:	aPrimitiveErrorNativeOpenCLRudesheim
		context:		aCLContext
		devices:		aCLDevicesCollection
		programs:		aProgramsCollection
		options:		anOptionsString
		buildLog:		aBuildLogString.
]

{ #category : 'accessing' }
ProgramLinkFailedOpenCLRudesheim >> buildLog [
	^ buildLog.
]

{ #category : 'accessing' }
ProgramLinkFailedOpenCLRudesheim >> buildLog: aBuildLogString [
	buildLog := aBuildLogString.
]

{ #category : 'accessing' }
ProgramLinkFailedOpenCLRudesheim >> context [
	^ context.
]

{ #category : 'accessing' }
ProgramLinkFailedOpenCLRudesheim >> context: aCLContext [
	context := aCLContext.
]

{ #category : 'accessing' }
ProgramLinkFailedOpenCLRudesheim >> contextDescription [
	^ 'linking ', self programs printString, ' for devices ', self devices printString, ' with options ''', self options, '''', ' on ', self context printString, ' - build log: ', self buildLog.
]

{ #category : 'accessing' }
ProgramLinkFailedOpenCLRudesheim >> devices [
	^ devices.
]

{ #category : 'accessing' }
ProgramLinkFailedOpenCLRudesheim >> devices: aCLDevicesCollection [
	devices := aCLDevicesCollection.
]

{ #category : 'accessing' }
ProgramLinkFailedOpenCLRudesheim >> options [
	^ options.
]

{ #category : 'accessing' }
ProgramLinkFailedOpenCLRudesheim >> options: anOptionsString [
	options := anOptionsString.
]

{ #category : 'accessing' }
ProgramLinkFailedOpenCLRudesheim >> programs [
	^ programs.
]

{ #category : 'accessing' }
ProgramLinkFailedOpenCLRudesheim >> programs: aProgramsCollection [
	programs := aProgramsCollection.
]

{ #category : 'signaling' }
ProgramLinkFailedOpenCLRudesheim >> signalForCause:	aPrimitiveErrorNativeOpenCLRudesheim
context:		aCLContext
devices:		aCLDevicesCollection
programs:		aProgramsCollection
options:		anOptionsString
buildLog:		aBuildLogString [

	self
		cause:		aPrimitiveErrorNativeOpenCLRudesheim;
		context:	aCLContext;
		devices:	aCLDevicesCollection;
		programs:	aProgramsCollection;
		options:	anOptionsString;
		buildLog:	aBuildLogString.

	^ super signal.
]

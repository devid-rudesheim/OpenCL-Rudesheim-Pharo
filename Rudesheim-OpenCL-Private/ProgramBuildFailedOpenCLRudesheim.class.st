Class {
	#name : 'ProgramBuildFailedOpenCLRudesheim',
	#superclass : 'DetailedPrimitiveErrorNativeOpenCLRudesheim',
	#instVars : [
		'program',
		'devices',
		'options',
		'buildLog'
	],
	#category : 'Rudesheim-OpenCL-Private-Errors-Program',
	#package : 'Rudesheim-OpenCL-Private',
	#tag : 'Errors-Program'
}

{ #category : 'instance creation' }
ProgramBuildFailedOpenCLRudesheim class >> signalForCause:	aPrimitiveErrorNativeOpenCLRudesheim
program:		aProgramOpenCLRudesheim
devices:		aCLDevicesCollection
options:		anOptionsString
buildLog:		aBuildLogString [

	^ self basicNew
		signalForCause:	aPrimitiveErrorNativeOpenCLRudesheim
		program:		aProgramOpenCLRudesheim
		devices:		aCLDevicesCollection
		options:		anOptionsString
		buildLog:		aBuildLogString.
]

{ #category : 'accessing' }
ProgramBuildFailedOpenCLRudesheim >> buildLog [
	^ buildLog.
]

{ #category : 'accessing' }
ProgramBuildFailedOpenCLRudesheim >> buildLog: aBuildLogString [
	buildLog := aBuildLogString.
]

{ #category : 'accessing' }
ProgramBuildFailedOpenCLRudesheim >> contextDescription [
	^ 'building ', self program printString, ' for devices ', self devices printString, ' with options ''', self options, '''', ' - build log: ', self buildLog.
]

{ #category : 'accessing' }
ProgramBuildFailedOpenCLRudesheim >> devices [

	^ devices.

]

{ #category : 'accessing' }
ProgramBuildFailedOpenCLRudesheim >> devices: aCLDevicesCollection [

	devices := aCLDevicesCollection.

]

{ #category : 'accessing' }
ProgramBuildFailedOpenCLRudesheim >> options [

	^ options.

]

{ #category : 'accessing' }
ProgramBuildFailedOpenCLRudesheim >> options: anOptionsString [

	options := anOptionsString.

]

{ #category : 'accessing' }
ProgramBuildFailedOpenCLRudesheim >> program [

	^ program.

]

{ #category : 'accessing' }
ProgramBuildFailedOpenCLRudesheim >> program: aProgramOpenCLRudesheim [

	program := aProgramOpenCLRudesheim.

]

{ #category : 'signaling' }
ProgramBuildFailedOpenCLRudesheim >> signalForCause:	aPrimitiveErrorNativeOpenCLRudesheim
program:		aProgramOpenCLRudesheim
devices:		aCLDevicesCollection
options:		anOptionsString
buildLog:		aBuildLogString [

	self
		cause:		aPrimitiveErrorNativeOpenCLRudesheim;
		program:	aProgramOpenCLRudesheim;
		devices:	aCLDevicesCollection;
		options:	anOptionsString;
		buildLog:	aBuildLogString.

	^ super signal.
]

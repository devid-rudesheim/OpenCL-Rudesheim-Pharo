Class {
	#name : 'ProgramCompileNotSupportedOpenCLRudesheim',
	#superclass : 'NotSupportedOpenCLRudesheim',
	#instVars : [
		'program',
		'devices',
		'options',
		'headers'
	],
	#category : 'Rudesheim-OpenCL-Private-Errors-Program',
	#package : 'Rudesheim-OpenCL-Private',
	#tag : 'Errors-Program'
}

{ #category : 'instance creation' }
ProgramCompileNotSupportedOpenCLRudesheim class >> signalForProgram:	aProgramOpenCLRudesheim
devices:		aCLDevicesCollection
options:		anOptionsString
headers:		aHeaderAssociationsCollection [

	^ self basicNew
		signalForProgram:	aProgramOpenCLRudesheim
		devices:		aCLDevicesCollection
		options:		anOptionsString
		headers:		aHeaderAssociationsCollection.
]

{ #category : 'accessing' }
ProgramCompileNotSupportedOpenCLRudesheim >> contextDescription [
	^ 'compiling ', self program printString, ' for devices ', self devices printString, ' with options ''', self options, '''', ' and headers ', self headers printString, ' is not supported on this platform (this Mac''s OpenCL implementation crashes in clCompileProgram - a known limitation of Apple''s incomplete separate-compilation support)'.
]

{ #category : 'accessing' }
ProgramCompileNotSupportedOpenCLRudesheim >> devices [
	^ devices.
]

{ #category : 'accessing' }
ProgramCompileNotSupportedOpenCLRudesheim >> devices: aCLDevicesCollection [
	devices := aCLDevicesCollection.
]

{ #category : 'accessing' }
ProgramCompileNotSupportedOpenCLRudesheim >> headers [
	^ headers.
]

{ #category : 'accessing' }
ProgramCompileNotSupportedOpenCLRudesheim >> headers: aHeaderAssociationsCollection [
	headers := aHeaderAssociationsCollection.
]

{ #category : 'accessing' }
ProgramCompileNotSupportedOpenCLRudesheim >> options [
	^ options.
]

{ #category : 'accessing' }
ProgramCompileNotSupportedOpenCLRudesheim >> options: anOptionsString [
	options := anOptionsString.
]

{ #category : 'accessing' }
ProgramCompileNotSupportedOpenCLRudesheim >> program [
	^ program.
]

{ #category : 'accessing' }
ProgramCompileNotSupportedOpenCLRudesheim >> program: aProgramOpenCLRudesheim [
	program := aProgramOpenCLRudesheim.
]

{ #category : 'signaling' }
ProgramCompileNotSupportedOpenCLRudesheim >> signalForProgram:	aProgramOpenCLRudesheim
devices:		aCLDevicesCollection
options:		anOptionsString
headers:		aHeaderAssociationsCollection [

	self
		program:	aProgramOpenCLRudesheim;
		devices:	aCLDevicesCollection;
		options:	anOptionsString;
		headers:	aHeaderAssociationsCollection.

	^ self signal.
]

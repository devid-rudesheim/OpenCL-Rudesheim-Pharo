Class {
	#name : 'ProgramLinkNotSupportedOpenCLRudesheim',
	#superclass : 'NotSupportedOpenCLRudesheim',
	#instVars : [
		'context',
		'devices',
		'programs',
		'options'
	],
	#category : 'Rudesheim-OpenCL-Private-Errors-Program',
	#package : 'Rudesheim-OpenCL-Private',
	#tag : 'Errors-Program'
}

{ #category : 'instance creation' }
ProgramLinkNotSupportedOpenCLRudesheim class >> signalForContext:	aCLContext
devices:		aCLDevicesCollection
programs:		aProgramsCollection
options:		anOptionsString [

	^ self basicNew
		signalForContext:	aCLContext
		devices:		aCLDevicesCollection
		programs:		aProgramsCollection
		options:		anOptionsString.
]

{ #category : 'accessing' }
ProgramLinkNotSupportedOpenCLRudesheim >> context [
	^ context.
]

{ #category : 'accessing' }
ProgramLinkNotSupportedOpenCLRudesheim >> context: aCLContext [
	context := aCLContext.
]

{ #category : 'accessing' }
ProgramLinkNotSupportedOpenCLRudesheim >> contextDescription [
	^ 'linking ', self programs printString, ' for devices ', self devices printString, ' with options ''', self options, '''', ' on ', self context printString, ' is not supported on this platform (this Mac''s OpenCL implementation reports success from clLinkProgram but returns a null program handle - a known limitation of Apple''s incomplete separate-compilation support)'.
]

{ #category : 'accessing' }
ProgramLinkNotSupportedOpenCLRudesheim >> devices [
	^ devices.
]

{ #category : 'accessing' }
ProgramLinkNotSupportedOpenCLRudesheim >> devices: aCLDevicesCollection [
	devices := aCLDevicesCollection.
]

{ #category : 'accessing' }
ProgramLinkNotSupportedOpenCLRudesheim >> options [
	^ options.
]

{ #category : 'accessing' }
ProgramLinkNotSupportedOpenCLRudesheim >> options: anOptionsString [
	options := anOptionsString.
]

{ #category : 'accessing' }
ProgramLinkNotSupportedOpenCLRudesheim >> programs [
	^ programs.
]

{ #category : 'accessing' }
ProgramLinkNotSupportedOpenCLRudesheim >> programs: aProgramsCollection [
	programs := aProgramsCollection.
]

{ #category : 'signaling' }
ProgramLinkNotSupportedOpenCLRudesheim >> signalForContext:	aCLContext
devices:		aCLDevicesCollection
programs:		aProgramsCollection
options:		anOptionsString [

	self
		context:	aCLContext;
		devices:	aCLDevicesCollection;
		programs:	aProgramsCollection;
		options:	anOptionsString.

	^ self signal.
]

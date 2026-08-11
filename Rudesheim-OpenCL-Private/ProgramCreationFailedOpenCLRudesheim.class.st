Class {
	#name : 'ProgramCreationFailedOpenCLRudesheim',
	#superclass : 'DetailedPrimitiveErrorNativeOpenCLRudesheim',
	#instVars : [
		'context',
		'sources'
	],
	#category : 'Rudesheim-OpenCL-Private-Errors-Creation',
	#package : 'Rudesheim-OpenCL-Private',
	#tag : 'Errors-Creation'
}

{ #category : 'instance creation' }
ProgramCreationFailedOpenCLRudesheim class >> signalForCause:	aPrimitiveErrorNativeOpenCLRudesheim
context:				aCLContext
sources:				aStringCollection [

	^ self basicNew
		signalForCause:	aPrimitiveErrorNativeOpenCLRudesheim
		context:				aCLContext
		sources:				aStringCollection.

]

{ #category : 'accessing' }
ProgramCreationFailedOpenCLRudesheim >> context [

	^ context.

]

{ #category : 'accessing' }
ProgramCreationFailedOpenCLRudesheim >> context: aCLContext [

	context := aCLContext.

]

{ #category : 'accessing' }
ProgramCreationFailedOpenCLRudesheim >> contextDescription [

	^ 'creating a program from ', self sources size printString, ' source(s) on ', self context printString.

]

{ #category : 'signaling' }
ProgramCreationFailedOpenCLRudesheim >> signalForCause:	aPrimitiveErrorNativeOpenCLRudesheim
context:				aCLContext
sources:				aStringCollection [

	self
		cause:		aPrimitiveErrorNativeOpenCLRudesheim;
		context:	aCLContext;
		sources:	aStringCollection.

	^ super signal.

]

{ #category : 'accessing' }
ProgramCreationFailedOpenCLRudesheim >> sources [

	^ sources.

]

{ #category : 'accessing' }
ProgramCreationFailedOpenCLRudesheim >> sources: aStringCollection [

	sources := aStringCollection.

]

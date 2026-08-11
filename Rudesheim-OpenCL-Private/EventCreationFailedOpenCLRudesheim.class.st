Class {
	#name : 'EventCreationFailedOpenCLRudesheim',
	#superclass : 'DetailedPrimitiveErrorNativeOpenCLRudesheim',
	#instVars : [
		'context'
	],
	#category : 'Rudesheim-OpenCL-Private-Errors-Creation',
	#package : 'Rudesheim-OpenCL-Private',
	#tag : 'Errors-Creation'
}

{ #category : 'instance creation' }
EventCreationFailedOpenCLRudesheim class >> signalForCause:	aPrimitiveErrorNativeOpenCLRudesheim
context:				aCLContext [

	^ self basicNew
		signalForCause:	aPrimitiveErrorNativeOpenCLRudesheim
		context:				aCLContext.

]

{ #category : 'accessing' }
EventCreationFailedOpenCLRudesheim >> context [

	^ context.

]

{ #category : 'accessing' }
EventCreationFailedOpenCLRudesheim >> context: aCLContext [

	context := aCLContext.

]

{ #category : 'accessing' }
EventCreationFailedOpenCLRudesheim >> contextDescription [

	^ 'creating an event on ', self context printString.

]

{ #category : 'signaling' }
EventCreationFailedOpenCLRudesheim >> signalForCause:	aPrimitiveErrorNativeOpenCLRudesheim
context:				aCLContext [

	self
		cause:		aPrimitiveErrorNativeOpenCLRudesheim;
		context:	aCLContext.

	^ super signal.

]

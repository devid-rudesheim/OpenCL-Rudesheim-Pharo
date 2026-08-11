Class {
	#name : 'ContextCreationFailedOpenCLRudesheim',
	#superclass : 'DetailedPrimitiveErrorNativeOpenCLRudesheim',
	#instVars : [
		'devices'
	],
	#category : 'Rudesheim-OpenCL-Private-Errors-Creation',
	#package : 'Rudesheim-OpenCL-Private',
	#tag : 'Errors-Creation'
}

{ #category : 'instance creation' }
ContextCreationFailedOpenCLRudesheim class >> signalForCause:	aPrimitiveErrorNativeOpenCLRudesheim
devices:				aCLDevices [

	^ self basicNew
		signalForCause:	aPrimitiveErrorNativeOpenCLRudesheim
		devices:				aCLDevices.

]

{ #category : 'accessing' }
ContextCreationFailedOpenCLRudesheim >> contextDescription [

	^ 'creating a context for devices ', self devices printString.

]

{ #category : 'accessing' }
ContextCreationFailedOpenCLRudesheim >> devices [

	^ devices.

]

{ #category : 'accessing' }
ContextCreationFailedOpenCLRudesheim >> devices: aCLDevices [

	devices := aCLDevices.

]

{ #category : 'signaling' }
ContextCreationFailedOpenCLRudesheim >> signalForCause:	aPrimitiveErrorNativeOpenCLRudesheim
devices:				aCLDevices [

	self
		cause:		aPrimitiveErrorNativeOpenCLRudesheim;
		devices:	aCLDevices.

	^ super signal.

]

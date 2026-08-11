Class {
	#name : 'CommandQueueCreationFailedOpenCLRudesheim',
	#superclass : 'DetailedPrimitiveErrorNativeOpenCLRudesheim',
	#instVars : [
		'device',
		'context'
	],
	#category : 'Rudesheim-OpenCL-Private-Errors-Creation',
	#package : 'Rudesheim-OpenCL-Private',
	#tag : 'Errors-Creation'
}

{ #category : 'instance creation' }
CommandQueueCreationFailedOpenCLRudesheim class >> signalForCause:	aPrimitiveErrorNativeOpenCLRudesheim
device:				aCLDevice
context:				aCLContext [

	^ self basicNew
		signalForCause:	aPrimitiveErrorNativeOpenCLRudesheim
		device:				aCLDevice
		context:				aCLContext.

]

{ #category : 'accessing' }
CommandQueueCreationFailedOpenCLRudesheim >> context [

	^ context.

]

{ #category : 'accessing' }
CommandQueueCreationFailedOpenCLRudesheim >> context: aCLContext [

	context := aCLContext.

]

{ #category : 'accessing' }
CommandQueueCreationFailedOpenCLRudesheim >> contextDescription [

	^ 'creating a command queue for ', self device printString, ' on ', self context printString.

]

{ #category : 'accessing' }
CommandQueueCreationFailedOpenCLRudesheim >> device [

	^ device.

]

{ #category : 'accessing' }
CommandQueueCreationFailedOpenCLRudesheim >> device: aCLDevice [

	device := aCLDevice.

]

{ #category : 'signaling' }
CommandQueueCreationFailedOpenCLRudesheim >> signalForCause:	aPrimitiveErrorNativeOpenCLRudesheim
device:				aCLDevice
context:				aCLContext [

	self
		cause:		aPrimitiveErrorNativeOpenCLRudesheim;
		device:		aCLDevice;
		context:	aCLContext.

	^ super signal.

]

Class {
	#name : 'CommandQueueFlushFailedOpenCLRudesheim',
	#superclass : 'DetailedPrimitiveErrorNativeOpenCLRudesheim',
	#instVars : [
		'commandQueue'
	],
	#category : 'Rudesheim-OpenCL-Private-Errors-Other',
	#package : 'Rudesheim-OpenCL-Private',
	#tag : 'Errors-Other'
}

{ #category : 'instance creation' }
CommandQueueFlushFailedOpenCLRudesheim class >> signalForCause:	aPrimitiveErrorNativeOpenCLRudesheim
commandQueue:		aCommandQueueOpenCLRudesheim [

	^ self basicNew
		signalForCause:	aPrimitiveErrorNativeOpenCLRudesheim
		commandQueue:		aCommandQueueOpenCLRudesheim.

]

{ #category : 'accessing' }
CommandQueueFlushFailedOpenCLRudesheim >> commandQueue [

	^ commandQueue.

]

{ #category : 'accessing' }
CommandQueueFlushFailedOpenCLRudesheim >> commandQueue: aCommandQueueOpenCLRudesheim [

	commandQueue := aCommandQueueOpenCLRudesheim.

]

{ #category : 'accessing' }
CommandQueueFlushFailedOpenCLRudesheim >> contextDescription [

	^ 'flushing ', self commandQueue printString.

]

{ #category : 'signaling' }
CommandQueueFlushFailedOpenCLRudesheim >> signalForCause:	aPrimitiveErrorNativeOpenCLRudesheim
commandQueue:		aCommandQueueOpenCLRudesheim [

	self
		cause:				aPrimitiveErrorNativeOpenCLRudesheim;
		commandQueue:		aCommandQueueOpenCLRudesheim.

	^ super signal.

]

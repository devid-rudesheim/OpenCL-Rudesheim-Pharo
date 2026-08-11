Class {
	#name : 'EventWaitFailedOpenCLRudesheim',
	#superclass : 'DetailedPrimitiveErrorNativeOpenCLRudesheim',
	#instVars : [
		'events'
	],
	#category : 'Rudesheim-OpenCL-Private-Errors-Other',
	#package : 'Rudesheim-OpenCL-Private',
	#tag : 'Errors-Other'
}

{ #category : 'instance creation' }
EventWaitFailedOpenCLRudesheim class >> signalForCause:	aPrimitiveErrorNativeOpenCLRudesheim
events:				aCLEventCollection [

	^ self basicNew
		signalForCause:	aPrimitiveErrorNativeOpenCLRudesheim
		events:				aCLEventCollection.

]

{ #category : 'accessing' }
EventWaitFailedOpenCLRudesheim >> contextDescription [

	^ 'waiting for events ', self events printString.

]

{ #category : 'accessing' }
EventWaitFailedOpenCLRudesheim >> events [

	^ events.

]

{ #category : 'accessing' }
EventWaitFailedOpenCLRudesheim >> events: aCLEventCollection [

	events := aCLEventCollection.

]

{ #category : 'signaling' }
EventWaitFailedOpenCLRudesheim >> signalForCause:	aPrimitiveErrorNativeOpenCLRudesheim
events:				aCLEventCollection [

	self
		cause:		aPrimitiveErrorNativeOpenCLRudesheim;
		events:	aCLEventCollection.

	^ super signal.

]

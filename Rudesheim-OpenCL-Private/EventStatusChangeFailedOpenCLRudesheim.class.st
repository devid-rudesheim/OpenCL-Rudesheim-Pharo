Class {
	#name : 'EventStatusChangeFailedOpenCLRudesheim',
	#superclass : 'DetailedPrimitiveErrorNativeOpenCLRudesheim',
	#instVars : [
		'event',
		'status'
	],
	#category : 'Rudesheim-OpenCL-Private-Errors-Other',
	#package : 'Rudesheim-OpenCL-Private',
	#tag : 'Errors-Other'
}

{ #category : 'instance creation' }
EventStatusChangeFailedOpenCLRudesheim class >> signalForCause:	aPrimitiveErrorNativeOpenCLRudesheim
event:				aCLEvent
status:				aStatusInteger [

	^ self basicNew
		signalForCause:	aPrimitiveErrorNativeOpenCLRudesheim
		event:				aCLEvent
		status:				aStatusInteger.

]

{ #category : 'accessing' }
EventStatusChangeFailedOpenCLRudesheim >> contextDescription [

	^ 'setting status of ', self event printString, ' to ', self status printString.

]

{ #category : 'accessing' }
EventStatusChangeFailedOpenCLRudesheim >> event [

	^ event.

]

{ #category : 'accessing' }
EventStatusChangeFailedOpenCLRudesheim >> event: aCLEvent [

	event := aCLEvent.

]

{ #category : 'signaling' }
EventStatusChangeFailedOpenCLRudesheim >> signalForCause:	aPrimitiveErrorNativeOpenCLRudesheim
event:				aCLEvent
status:				aStatusInteger [

	self
		cause:		aPrimitiveErrorNativeOpenCLRudesheim;
		event:		aCLEvent;
		status:	aStatusInteger.

	^ super signal.

]

{ #category : 'accessing' }
EventStatusChangeFailedOpenCLRudesheim >> status [

	^ status.

]

{ #category : 'accessing' }
EventStatusChangeFailedOpenCLRudesheim >> status: aStatusInteger [

	status := aStatusInteger.

]

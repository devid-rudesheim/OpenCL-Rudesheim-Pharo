Class {
	#name : 'EnqueueMapFailedOpenCLRudesheim',
	#superclass : 'DetailedPrimitiveErrorNativeOpenCLRudesheim',
	#instVars : [
		'commandQueue',
		'buffer',
		'range',
		'options',
		'blocking'
	],
	#category : 'Rudesheim-OpenCL-Private-Errors-Enqueue',
	#package : 'Rudesheim-OpenCL-Private',
	#tag : 'Errors-Enqueue'
}

{ #category : 'instance creation' }
EnqueueMapFailedOpenCLRudesheim class >> signalForCause:	aPrimitiveErrorNativeOpenCLRudesheim
commandQueue:		aCommandQueueOpenCLRudesheim
buffer:				aCLBuffer
range:				aRangeInterval
options:				anOptions
blocking:			aBloolean [

	^ self basicNew
		signalForCause:	aPrimitiveErrorNativeOpenCLRudesheim
		commandQueue:		aCommandQueueOpenCLRudesheim
		buffer:				aCLBuffer
		range:				aRangeInterval
		options:				anOptions
		blocking:			aBloolean.

]

{ #category : 'accessing' }
EnqueueMapFailedOpenCLRudesheim >> blocking [

	^ blocking.

]

{ #category : 'accessing' }
EnqueueMapFailedOpenCLRudesheim >> blocking: aBloolean [

	blocking := aBloolean.

]

{ #category : 'accessing' }
EnqueueMapFailedOpenCLRudesheim >> buffer [

	^ buffer.

]

{ #category : 'accessing' }
EnqueueMapFailedOpenCLRudesheim >> buffer: aCLBuffer [

	buffer := aCLBuffer.

]

{ #category : 'accessing' }
EnqueueMapFailedOpenCLRudesheim >> commandQueue [

	^ commandQueue.

]

{ #category : 'accessing' }
EnqueueMapFailedOpenCLRudesheim >> commandQueue: aCommandQueueOpenCLRudesheim [

	commandQueue := aCommandQueueOpenCLRudesheim.

]

{ #category : 'accessing' }
EnqueueMapFailedOpenCLRudesheim >> contextDescription [

	^ 'enqueueing a map of ', self buffer printString, ' for range ', self range printString, ' on ', self commandQueue printString.

]

{ #category : 'accessing' }
EnqueueMapFailedOpenCLRudesheim >> options [

	^ options.

]

{ #category : 'accessing' }
EnqueueMapFailedOpenCLRudesheim >> options: anOptions [

	options := anOptions.

]

{ #category : 'accessing' }
EnqueueMapFailedOpenCLRudesheim >> range [

	^ range.

]

{ #category : 'accessing' }
EnqueueMapFailedOpenCLRudesheim >> range: aRangeInterval [

	range := aRangeInterval.

]

{ #category : 'signaling' }
EnqueueMapFailedOpenCLRudesheim >> signalForCause:	aPrimitiveErrorNativeOpenCLRudesheim
commandQueue:		aCommandQueueOpenCLRudesheim
buffer:				aCLBuffer
range:				aRangeInterval
options:				anOptions
blocking:			aBloolean [

	self
		cause:				aPrimitiveErrorNativeOpenCLRudesheim;
		commandQueue:		aCommandQueueOpenCLRudesheim;
		buffer:				aCLBuffer;
		range:				aRangeInterval;
		options:				anOptions;
		blocking:			aBloolean.

	^ super signal.

]

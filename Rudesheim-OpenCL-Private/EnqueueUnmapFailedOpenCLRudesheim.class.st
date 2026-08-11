Class {
	#name : 'EnqueueUnmapFailedOpenCLRudesheim',
	#superclass : 'DetailedPrimitiveErrorNativeOpenCLRudesheim',
	#instVars : [
		'commandQueue',
		'buffer'
	],
	#category : 'Rudesheim-OpenCL-Private-Errors-Enqueue',
	#package : 'Rudesheim-OpenCL-Private',
	#tag : 'Errors-Enqueue'
}

{ #category : 'instance creation' }
EnqueueUnmapFailedOpenCLRudesheim class >> signalForCause:	aPrimitiveErrorNativeOpenCLRudesheim
commandQueue:		aCommandQueueOpenCLRudesheim
buffer:				aCLBuffer [

	^ self basicNew
		signalForCause:	aPrimitiveErrorNativeOpenCLRudesheim
		commandQueue:		aCommandQueueOpenCLRudesheim
		buffer:				aCLBuffer.

]

{ #category : 'accessing' }
EnqueueUnmapFailedOpenCLRudesheim >> buffer [

	^ buffer.

]

{ #category : 'accessing' }
EnqueueUnmapFailedOpenCLRudesheim >> buffer: aCLBuffer [

	buffer := aCLBuffer.

]

{ #category : 'accessing' }
EnqueueUnmapFailedOpenCLRudesheim >> commandQueue [

	^ commandQueue.

]

{ #category : 'accessing' }
EnqueueUnmapFailedOpenCLRudesheim >> commandQueue: aCommandQueueOpenCLRudesheim [

	commandQueue := aCommandQueueOpenCLRudesheim.

]

{ #category : 'accessing' }
EnqueueUnmapFailedOpenCLRudesheim >> contextDescription [

	^ 'enqueueing an unmap of ', self buffer printString, ' on ', self commandQueue printString.

]

{ #category : 'signaling' }
EnqueueUnmapFailedOpenCLRudesheim >> signalForCause:	aPrimitiveErrorNativeOpenCLRudesheim
commandQueue:		aCommandQueueOpenCLRudesheim
buffer:				aCLBuffer [

	self
		cause:				aPrimitiveErrorNativeOpenCLRudesheim;
		commandQueue:		aCommandQueueOpenCLRudesheim;
		buffer:				aCLBuffer.

	^ super signal.

]

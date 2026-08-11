Class {
	#name : 'EnqueueCopyFailedOpenCLRudesheim',
	#superclass : 'DetailedPrimitiveErrorNativeOpenCLRudesheim',
	#instVars : [
		'commandQueue',
		'inputBuffer',
		'outputBuffer',
		'offset',
		'range'
	],
	#category : 'Rudesheim-OpenCL-Private-Errors-Enqueue',
	#package : 'Rudesheim-OpenCL-Private',
	#tag : 'Errors-Enqueue'
}

{ #category : 'instance creation' }
EnqueueCopyFailedOpenCLRudesheim class >> signalForCause:	aPrimitiveErrorNativeOpenCLRudesheim
commandQueue:		aCommandQueueOpenCLRudesheim
inputBuffer:			anInputCLBuffer
outputBuffer:		anOutputCLBuffer
offset:				anOffset
range:				aRangeInterval [

	^ self basicNew
		signalForCause:	aPrimitiveErrorNativeOpenCLRudesheim
		commandQueue:		aCommandQueueOpenCLRudesheim
		inputBuffer:			anInputCLBuffer
		outputBuffer:		anOutputCLBuffer
		offset:				anOffset
		range:				aRangeInterval.

]

{ #category : 'accessing' }
EnqueueCopyFailedOpenCLRudesheim >> commandQueue [

	^ commandQueue.

]

{ #category : 'accessing' }
EnqueueCopyFailedOpenCLRudesheim >> commandQueue: aCommandQueueOpenCLRudesheim [

	commandQueue := aCommandQueueOpenCLRudesheim.

]

{ #category : 'accessing' }
EnqueueCopyFailedOpenCLRudesheim >> contextDescription [

	^ 'enqueueing a copy from ', self inputBuffer printString, ' to ', self outputBuffer printString, ' for range ', self range printString, ' on ', self commandQueue printString.

]

{ #category : 'accessing' }
EnqueueCopyFailedOpenCLRudesheim >> inputBuffer [

	^ inputBuffer.

]

{ #category : 'accessing' }
EnqueueCopyFailedOpenCLRudesheim >> inputBuffer: anInputCLBuffer [

	inputBuffer := anInputCLBuffer.

]

{ #category : 'accessing' }
EnqueueCopyFailedOpenCLRudesheim >> offset [

	^ offset.

]

{ #category : 'accessing' }
EnqueueCopyFailedOpenCLRudesheim >> offset: anOffset [

	offset := anOffset.

]

{ #category : 'accessing' }
EnqueueCopyFailedOpenCLRudesheim >> outputBuffer [

	^ outputBuffer.

]

{ #category : 'accessing' }
EnqueueCopyFailedOpenCLRudesheim >> outputBuffer: anOutputCLBuffer [

	outputBuffer := anOutputCLBuffer.

]

{ #category : 'accessing' }
EnqueueCopyFailedOpenCLRudesheim >> range [

	^ range.

]

{ #category : 'accessing' }
EnqueueCopyFailedOpenCLRudesheim >> range: aRangeInterval [

	range := aRangeInterval.

]

{ #category : 'signaling' }
EnqueueCopyFailedOpenCLRudesheim >> signalForCause:	aPrimitiveErrorNativeOpenCLRudesheim
commandQueue:		aCommandQueueOpenCLRudesheim
inputBuffer:			anInputCLBuffer
outputBuffer:		anOutputCLBuffer
offset:				anOffset
range:				aRangeInterval [

	self
		cause:				aPrimitiveErrorNativeOpenCLRudesheim;
		commandQueue:		aCommandQueueOpenCLRudesheim;
		inputBuffer:			anInputCLBuffer;
		outputBuffer:		anOutputCLBuffer;
		offset:				anOffset;
		range:				aRangeInterval.

	^ super signal.

]

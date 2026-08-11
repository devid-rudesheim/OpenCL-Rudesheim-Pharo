Class {
	#name : 'EnqueueFillFailedOpenCLRudesheim',
	#superclass : 'DetailedPrimitiveErrorNativeOpenCLRudesheim',
	#instVars : [
		'commandQueue',
		'buffer',
		'pattern',
		'range'
	],
	#category : 'Rudesheim-OpenCL-Private-Errors-Enqueue',
	#package : 'Rudesheim-OpenCL-Private',
	#tag : 'Errors-Enqueue'
}

{ #category : 'instance creation' }
EnqueueFillFailedOpenCLRudesheim class >> signalForCause:	aPrimitiveErrorNativeOpenCLRudesheim
commandQueue:		aCommandQueueOpenCLRudesheim
buffer:				aCLBuffer
pattern:				aPatternByteArray
range:				aRangeInterval [

	^ self basicNew
		signalForCause:	aPrimitiveErrorNativeOpenCLRudesheim
		commandQueue:		aCommandQueueOpenCLRudesheim
		buffer:				aCLBuffer
		pattern:				aPatternByteArray
		range:				aRangeInterval.

]

{ #category : 'accessing' }
EnqueueFillFailedOpenCLRudesheim >> buffer [

	^ buffer.

]

{ #category : 'accessing' }
EnqueueFillFailedOpenCLRudesheim >> buffer: aCLBuffer [

	buffer := aCLBuffer.

]

{ #category : 'accessing' }
EnqueueFillFailedOpenCLRudesheim >> commandQueue [

	^ commandQueue.

]

{ #category : 'accessing' }
EnqueueFillFailedOpenCLRudesheim >> commandQueue: aCommandQueueOpenCLRudesheim [

	commandQueue := aCommandQueueOpenCLRudesheim.

]

{ #category : 'accessing' }
EnqueueFillFailedOpenCLRudesheim >> contextDescription [

	^ 'enqueueing a fill of ', self buffer printString, ' for range ', self range printString, ' on ', self commandQueue printString.

]

{ #category : 'accessing' }
EnqueueFillFailedOpenCLRudesheim >> pattern [

	^ pattern.

]

{ #category : 'accessing' }
EnqueueFillFailedOpenCLRudesheim >> pattern: aPatternByteArray [

	pattern := aPatternByteArray.

]

{ #category : 'accessing' }
EnqueueFillFailedOpenCLRudesheim >> range [

	^ range.

]

{ #category : 'accessing' }
EnqueueFillFailedOpenCLRudesheim >> range: aRangeInterval [

	range := aRangeInterval.

]

{ #category : 'signaling' }
EnqueueFillFailedOpenCLRudesheim >> signalForCause:	aPrimitiveErrorNativeOpenCLRudesheim
commandQueue:		aCommandQueueOpenCLRudesheim
buffer:				aCLBuffer
pattern:				aPatternByteArray
range:				aRangeInterval [

	self
		cause:				aPrimitiveErrorNativeOpenCLRudesheim;
		commandQueue:		aCommandQueueOpenCLRudesheim;
		buffer:				aCLBuffer;
		pattern:				aPatternByteArray;
		range:				aRangeInterval.

	^ super signal.

]

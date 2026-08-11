Class {
	#name : 'EnqueueKernelFailedOpenCLRudesheim',
	#superclass : 'DetailedPrimitiveErrorNativeOpenCLRudesheim',
	#instVars : [
		'commandQueue',
		'kernel',
		'ndRange'
	],
	#category : 'Rudesheim-OpenCL-Private-Errors-Enqueue',
	#package : 'Rudesheim-OpenCL-Private',
	#tag : 'Errors-Enqueue'
}

{ #category : 'instance creation' }
EnqueueKernelFailedOpenCLRudesheim class >> signalForCause:	aPrimitiveErrorNativeOpenCLRudesheim
commandQueue:		aCommandQueueOpenCLRudesheim
kernel:				aCLKernel
ndRange:				aNDRange [

	^ self basicNew
		signalForCause:	aPrimitiveErrorNativeOpenCLRudesheim
		commandQueue:		aCommandQueueOpenCLRudesheim
		kernel:				aCLKernel
		ndRange:				aNDRange.

]

{ #category : 'accessing' }
EnqueueKernelFailedOpenCLRudesheim >> commandQueue [

	^ commandQueue.

]

{ #category : 'accessing' }
EnqueueKernelFailedOpenCLRudesheim >> commandQueue: aCommandQueueOpenCLRudesheim [

	commandQueue := aCommandQueueOpenCLRudesheim.

]

{ #category : 'accessing' }
EnqueueKernelFailedOpenCLRudesheim >> contextDescription [

	^ 'enqueueing ', self kernel printString, ' for range ', self ndRange printString, ' on ', self commandQueue printString.

]

{ #category : 'accessing' }
EnqueueKernelFailedOpenCLRudesheim >> kernel [

	^ kernel.

]

{ #category : 'accessing' }
EnqueueKernelFailedOpenCLRudesheim >> kernel: aCLKernel [

	kernel := aCLKernel.

]

{ #category : 'accessing' }
EnqueueKernelFailedOpenCLRudesheim >> ndRange [

	^ ndRange.

]

{ #category : 'accessing' }
EnqueueKernelFailedOpenCLRudesheim >> ndRange: aNDRange [

	ndRange := aNDRange.

]

{ #category : 'signaling' }
EnqueueKernelFailedOpenCLRudesheim >> signalForCause:	aPrimitiveErrorNativeOpenCLRudesheim
commandQueue:		aCommandQueueOpenCLRudesheim
kernel:				aCLKernel
ndRange:				aNDRange [

	self
		cause:				aPrimitiveErrorNativeOpenCLRudesheim;
		commandQueue:		aCommandQueueOpenCLRudesheim;
		kernel:				aCLKernel;
		ndRange:				aNDRange.

	^ super signal.

]

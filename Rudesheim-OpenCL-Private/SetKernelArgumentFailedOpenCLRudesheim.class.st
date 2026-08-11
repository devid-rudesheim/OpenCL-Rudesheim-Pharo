Class {
	#name : 'SetKernelArgumentFailedOpenCLRudesheim',
	#superclass : 'DetailedPrimitiveErrorNativeOpenCLRudesheim',
	#instVars : [
		'kernel',
		'argumentIndex',
		'argumentValue'
	],
	#category : 'Rudesheim-OpenCL-Private-Errors-Other',
	#package : 'Rudesheim-OpenCL-Private',
	#tag : 'Errors-Other'
}

{ #category : 'instance creation' }
SetKernelArgumentFailedOpenCLRudesheim class >> signalForCause:	aPrimitiveErrorNativeOpenCLRudesheim
kernel:				aKernelOpenCLRudesheim
argumentIndex:		anIndexInteger
argumentValue:		aCLValue [

	^ self basicNew
		signalForCause:	aPrimitiveErrorNativeOpenCLRudesheim
		kernel:				aKernelOpenCLRudesheim
		argumentIndex:		anIndexInteger
		argumentValue:		aCLValue.

]

{ #category : 'accessing' }
SetKernelArgumentFailedOpenCLRudesheim >> argumentIndex [

	^ argumentIndex.

]

{ #category : 'accessing' }
SetKernelArgumentFailedOpenCLRudesheim >> argumentIndex: anIndexInteger [

	argumentIndex := anIndexInteger.

]

{ #category : 'accessing' }
SetKernelArgumentFailedOpenCLRudesheim >> argumentValue [

	^ argumentValue.

]

{ #category : 'accessing' }
SetKernelArgumentFailedOpenCLRudesheim >> argumentValue: aCLValue [

	argumentValue := aCLValue.

]

{ #category : 'accessing' }
SetKernelArgumentFailedOpenCLRudesheim >> contextDescription [

	^ 'setting argument ', self argumentIndex printString, ' of ', self kernel printString, ' to ', self argumentValue printString.

]

{ #category : 'accessing' }
SetKernelArgumentFailedOpenCLRudesheim >> kernel [

	^ kernel.

]

{ #category : 'accessing' }
SetKernelArgumentFailedOpenCLRudesheim >> kernel: aKernelOpenCLRudesheim [

	kernel := aKernelOpenCLRudesheim.

]

{ #category : 'signaling' }
SetKernelArgumentFailedOpenCLRudesheim >> signalForCause:	aPrimitiveErrorNativeOpenCLRudesheim
kernel:				aKernelOpenCLRudesheim
argumentIndex:		anIndexInteger
argumentValue:		aCLValue [

	self
		cause:				aPrimitiveErrorNativeOpenCLRudesheim;
		kernel:				aKernelOpenCLRudesheim;
		argumentIndex:		anIndexInteger;
		argumentValue:		aCLValue.

	^ super signal.

]

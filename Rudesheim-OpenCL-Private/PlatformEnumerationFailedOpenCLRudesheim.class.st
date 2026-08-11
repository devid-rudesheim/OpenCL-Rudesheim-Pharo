Class {
	#name : 'PlatformEnumerationFailedOpenCLRudesheim',
	#superclass : 'DetailedPrimitiveErrorNativeOpenCLRudesheim',
	#category : 'Rudesheim-OpenCL-Private-Errors-Other',
	#package : 'Rudesheim-OpenCL-Private',
	#tag : 'Errors-Other'
}

{ #category : 'instance creation' }
PlatformEnumerationFailedOpenCLRudesheim class >> signalForCause:	aPrimitiveErrorNativeOpenCLRudesheim [

	^ self basicNew
		signalForCause:	aPrimitiveErrorNativeOpenCLRudesheim.

]

{ #category : 'accessing' }
PlatformEnumerationFailedOpenCLRudesheim >> contextDescription [

	^ 'enumerating OpenCL platforms'.

]

{ #category : 'signaling' }
PlatformEnumerationFailedOpenCLRudesheim >> signalForCause:	aPrimitiveErrorNativeOpenCLRudesheim [

	self
		cause:	aPrimitiveErrorNativeOpenCLRudesheim.

	^ super signal.

]

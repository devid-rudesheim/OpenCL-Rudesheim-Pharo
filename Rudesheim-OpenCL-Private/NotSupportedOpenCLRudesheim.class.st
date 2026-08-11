"
Abstract superclass for a failure that is not a native OpenCL error - the native call was never attempted because this platform is known not to support the operation (see MacOSOpenCLRudesheim). Unlike DetailedPrimitiveErrorNativeOpenCLRudesheim, there is no native error code or cause to carry.
"
Class {
	#name : 'NotSupportedOpenCLRudesheim',
	#superclass : 'Error',
	#category : 'Rudesheim-OpenCL-Private-Errors-Core',
	#package : 'Rudesheim-OpenCL-Private',
	#tag : 'Errors-Core'
}

{ #category : 'accessing' }
NotSupportedOpenCLRudesheim >> contextDescription [
	^ self subclassResponsibility.
]

{ #category : 'accessing' }
NotSupportedOpenCLRudesheim >> messageText [
	^ self contextDescription.
]

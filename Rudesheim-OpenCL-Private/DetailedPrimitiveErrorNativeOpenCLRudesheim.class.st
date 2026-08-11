Class {
	#name : 'DetailedPrimitiveErrorNativeOpenCLRudesheim',
	#superclass : 'PrimitiveErrorNativeOpenCLRudesheim',
	#instVars : [
		'cause'
	],
	#category : 'Rudesheim-OpenCL-Private-Errors-Core',
	#package : 'Rudesheim-OpenCL-Private',
	#tag : 'Errors-Core'
}

{ #category : 'accessing' }
DetailedPrimitiveErrorNativeOpenCLRudesheim >> cause [

	^ cause.

]

{ #category : 'accessing' }
DetailedPrimitiveErrorNativeOpenCLRudesheim >> cause: aPrimitiveErrorNativeOpenCLRudesheim [

	cause := aPrimitiveErrorNativeOpenCLRudesheim.

]

{ #category : 'accessing' }
DetailedPrimitiveErrorNativeOpenCLRudesheim >> contextDescription [

	^ self subclassResponsibility.

]

{ #category : 'accessing' }
DetailedPrimitiveErrorNativeOpenCLRudesheim >> errorCode [

	^ self cause errorCode.

]

{ #category : 'accessing' }
DetailedPrimitiveErrorNativeOpenCLRudesheim >> messageText [

	^ self contextDescription, ' failed: ', self cause messageText.

]

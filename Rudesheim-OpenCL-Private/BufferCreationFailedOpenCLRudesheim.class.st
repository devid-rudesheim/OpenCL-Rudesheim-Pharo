Class {
	#name : 'BufferCreationFailedOpenCLRudesheim',
	#superclass : 'DetailedPrimitiveErrorNativeOpenCLRudesheim',
	#instVars : [
		'context',
		'options',
		'sizeInBytes'
	],
	#category : 'Rudesheim-OpenCL-Private-Errors-Creation',
	#package : 'Rudesheim-OpenCL-Private',
	#tag : 'Errors-Creation'
}

{ #category : 'instance creation' }
BufferCreationFailedOpenCLRudesheim class >> signalForCause:	aPrimitiveErrorNativeOpenCLRudesheim
context:				aCLContext
options:				aCLTBufferDefineCollection
sizeInBytes:			aSizeInteger [

	^ self basicNew
		signalForCause:	aPrimitiveErrorNativeOpenCLRudesheim
		context:				aCLContext
		options:				aCLTBufferDefineCollection
		sizeInBytes:			aSizeInteger.

]

{ #category : 'accessing' }
BufferCreationFailedOpenCLRudesheim >> context [

	^ context.

]

{ #category : 'accessing' }
BufferCreationFailedOpenCLRudesheim >> context: aCLContext [

	context := aCLContext.

]

{ #category : 'accessing' }
BufferCreationFailedOpenCLRudesheim >> contextDescription [

	^ 'creating a buffer of ', self sizeInBytes printString, ' bytes with options ', self options printString, ' on ', self context printString.

]

{ #category : 'accessing' }
BufferCreationFailedOpenCLRudesheim >> options [

	^ options.

]

{ #category : 'accessing' }
BufferCreationFailedOpenCLRudesheim >> options: aCLTBufferDefineCollection [

	options := aCLTBufferDefineCollection.

]

{ #category : 'signaling' }
BufferCreationFailedOpenCLRudesheim >> signalForCause:	aPrimitiveErrorNativeOpenCLRudesheim
context:				aCLContext
options:				aCLTBufferDefineCollection
sizeInBytes:			aSizeInteger [

	self
		cause:			aPrimitiveErrorNativeOpenCLRudesheim;
		context:			aCLContext;
		options:			aCLTBufferDefineCollection;
		sizeInBytes:		aSizeInteger.

	^ super signal.

]

{ #category : 'accessing' }
BufferCreationFailedOpenCLRudesheim >> sizeInBytes [

	^ sizeInBytes.

]

{ #category : 'accessing' }
BufferCreationFailedOpenCLRudesheim >> sizeInBytes: aSizeInteger [

	sizeInBytes := aSizeInteger.

]

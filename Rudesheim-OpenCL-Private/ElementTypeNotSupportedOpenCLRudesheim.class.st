Class {
	#name : 'ElementTypeNotSupportedOpenCLRudesheim',
	#superclass : 'Error',
	#instVars : [
		'elementType'
	],
	#category : 'Rudesheim-OpenCL-Private-Errors-Core',
	#package : 'Rudesheim-OpenCL-Private',
	#tag : 'Errors-Core'
}

{ #category : 'instance creation' }
ElementTypeNotSupportedOpenCLRudesheim class >> signalForElementType:	aTFBasicType [

	^ self basicNew
		signalForElementType:	aTFBasicType.
]

{ #category : 'accessing' }
ElementTypeNotSupportedOpenCLRudesheim >> elementType [

	^ elementType.
]

{ #category : 'accessing' }
ElementTypeNotSupportedOpenCLRudesheim >> elementType:	aTFBasicType [

	elementType := aTFBasicType.
]

{ #category : 'accessing' }
ElementTypeNotSupportedOpenCLRudesheim >> messageText [

	^ self
		elementType
		printString
		, ' is not a supported OpenCL buffer element type.'.
]

{ #category : 'signaling' }
ElementTypeNotSupportedOpenCLRudesheim >> signalForElementType:	aTFBasicType [

	self
		elementType:	aTFBasicType.

	^ self signal.
]

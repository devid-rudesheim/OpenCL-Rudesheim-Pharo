Class {
	#name : 'DeviceEnumerationFailedOpenCLRudesheim',
	#superclass : 'DetailedPrimitiveErrorNativeOpenCLRudesheim',
	#instVars : [
		'platform',
		'deviceTypes'
	],
	#category : 'Rudesheim-OpenCL-Private-Errors-Other',
	#package : 'Rudesheim-OpenCL-Private',
	#tag : 'Errors-Other'
}

{ #category : 'instance creation' }
DeviceEnumerationFailedOpenCLRudesheim class >> signalForCause:	aPrimitiveErrorNativeOpenCLRudesheim
platform:				aCLPlatform
deviceTypes:			aCLTDeviceDefineCollection [

	^ self basicNew
		signalForCause:	aPrimitiveErrorNativeOpenCLRudesheim
		platform:				aCLPlatform
		deviceTypes:			aCLTDeviceDefineCollection.

]

{ #category : 'accessing' }
DeviceEnumerationFailedOpenCLRudesheim >> contextDescription [

	^ 'enumerating devices of type ', self deviceTypes printString, ' on ', self platform printString.

]

{ #category : 'accessing' }
DeviceEnumerationFailedOpenCLRudesheim >> deviceTypes [

	^ deviceTypes.

]

{ #category : 'accessing' }
DeviceEnumerationFailedOpenCLRudesheim >> deviceTypes: aCLTDeviceDefineCollection [

	deviceTypes := aCLTDeviceDefineCollection.

]

{ #category : 'accessing' }
DeviceEnumerationFailedOpenCLRudesheim >> platform [

	^ platform.

]

{ #category : 'accessing' }
DeviceEnumerationFailedOpenCLRudesheim >> platform: aCLPlatform [

	platform := aCLPlatform.

]

{ #category : 'signaling' }
DeviceEnumerationFailedOpenCLRudesheim >> signalForCause:	aPrimitiveErrorNativeOpenCLRudesheim
platform:				aCLPlatform
deviceTypes:			aCLTDeviceDefineCollection [

	self
		cause:			aPrimitiveErrorNativeOpenCLRudesheim;
		platform:		aCLPlatform;
		deviceTypes:	aCLTDeviceDefineCollection.

	^ super signal.

]

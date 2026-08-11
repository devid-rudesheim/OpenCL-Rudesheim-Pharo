Class {
	#name : 'PlatformOpenCLRudesheim',
	#superclass : 'IDNativeOpenCLRudesheim',
	#category : 'Rudesheim-OpenCL-Private-Objects',
	#package : 'Rudesheim-OpenCL-Private',
	#tag : 'Objects'
}

{ #category : 'instance creation' }
PlatformOpenCLRudesheim class >> clPlatforms [
	|
		functions
	|

	functions := Rudesheim OpenCL Native Functions.

	^
	[
		super
			onDo:
			[ :expectedAmount :actualIDs :actualAmount |

				functions tfRunner
					invokeFunction:	functions functionOfGetPlatformIDs
					withArguments:
					{
						expectedAmount.
						actualIDs.
						actualAmount.
					}.

			].
	]
		on: PrimitiveErrorNativeOpenCLRudesheim
		do:
		[ :anError |
			Rudesheim OpenCL Native Error PlatformEnumerationFailed
				signalForCause:	anError.
		].


]

{ #category : 'accessing' }
PlatformOpenCLRudesheim >> clDevices [

	^ self
		clDevicesForType:
		{
			Rudesheim OpenCL All
		}.
]

{ #category : 'accessing' }
PlatformOpenCLRudesheim >> clDevicesForType:	aCLTDeviceDefineCollection [

	^ Rudesheim OpenCL Device
		clDevicesForType:	aCLTDeviceDefineCollection
		of:					self
]

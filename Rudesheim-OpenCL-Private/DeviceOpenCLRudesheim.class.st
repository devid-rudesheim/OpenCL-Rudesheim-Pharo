Class {
	#name : 'DeviceOpenCLRudesheim',
	#superclass : 'IDNativeOpenCLRudesheim',
	#category : 'Rudesheim-OpenCL-Private-Objects',
	#package : 'Rudesheim-OpenCL-Private',
	#tag : 'Objects'
}

{ #category : 'instance creation' }
DeviceOpenCLRudesheim class >> clDevicesForType:	aCLTDeviceDefineCollection
of:					aCLPlatform [
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
					invokeFunction:	functions functionOfGetDeviceIDs
					withArguments:
					{
						aCLPlatform idPointer.
						aCLTDeviceDefineCollection
							inject: 0
							into:
							[ :value :each |
								value | each  clDeviceType.
							].
						expectedAmount.
						actualIDs.
						actualAmount.
					}.

			].
	]
		on: PrimitiveErrorNativeOpenCLRudesheim
		do:
		[ :anError |
			Rudesheim OpenCL Native Error DeviceEnumerationFailed
				signalForCause:	anError
				platform:			aCLPlatform
				deviceTypes:		aCLTDeviceDefineCollection.
		].

]

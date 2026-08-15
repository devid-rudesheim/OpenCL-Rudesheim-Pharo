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
				|
					deviceTypeMask
				|

				deviceTypeMask :=
					aCLTDeviceDefineCollection
						inject: 0
						into:
						[ :value :each |
							value | each  clDeviceType.
						].

				Transcript
					showCr:
						'DEBUG clGetDeviceIDs args: platform=',
						aCLPlatform idPointer printString,
						' deviceTypeMask=',
						deviceTypeMask printString,
						' expectedAmount=',
						expectedAmount printString,
						' actualIDs=',
						actualIDs printString,
						' actualAmount=',
						actualAmount printString;
					flush.

				functions tfRunner
					invokeFunction:	functions functionOfGetDeviceIDs
					withArguments:
					{
						aCLPlatform idPointer.
						deviceTypeMask.
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

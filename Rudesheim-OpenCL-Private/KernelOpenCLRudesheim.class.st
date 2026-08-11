Class {
	#name : 'KernelOpenCLRudesheim',
	#superclass : 'HandleNativeOpenCLRudesheim',
	#instVars : [
		'parameterTypes'
	],
	#category : 'Rudesheim-OpenCL-Private-Objects',
	#package : 'Rudesheim-OpenCL-Private',
	#tag : 'Objects'
}

{ #category : 'instance creation' }
KernelOpenCLRudesheim class >> clKernelAt:				aNameString
withParameterTypes:	aCTypeSequencialCollection
of: 					aCLProgram [

	^
	[
		(
			super
				newWithArguments:
				{
					aCLProgram handlePointer.
					aNameString utf8Encoded tfPointerAddress.
				}
		)
			parameterTypes:	aCTypeSequencialCollection;
			yourself
	]
		on: PrimitiveErrorNativeOpenCLRudesheim
		do:
		[ :anError |
			Rudesheim OpenCL Native Error KernelCreationFailed
				signalForCause:		anError
				kernelName:			aNameString
				parameterTypes:		aCTypeSequencialCollection
				program:				aCLProgram.
		].

]

{ #category : 'accessing' }
KernelOpenCLRudesheim class >> functionsOfCreationAndRelease [

	^ Rudesheim OpenCL Native Functions functionsOfKernel.
]

{ #category : 'instance creation' }
KernelOpenCLRudesheim class >> newWithArguments:	aArgumentsSequencialCollection [
	
	^ self shouldNotImplement.
]

{ #category : 'accessing' }
KernelOpenCLRudesheim >> at:		anIndexInteger
put:	aCLValue [
	|
		native
		functions
		size
		type
		pointer
	|

	native := Rudesheim OpenCL Native.
	functions := native Functions.

	type :=
		self parameterTypes
			at:	anIndexInteger.

	size := type byteSize.
	pointer :=
		ExternalAddress
			gcallocate:		size.

	type
		write:	aCLValue asValueForCL
		into:	pointer.

	[
		native Error Primitive
			shouldZero:
			[
				functions tfRunner
					invokeFunction:	functions functionsOfSetKernelArg
					withArguments:
					{
						self handlePointer.
						anIndexInteger - 1.
						size.
						pointer.
					}.
			].
	]
		on: PrimitiveErrorNativeOpenCLRudesheim
		do:
		[ :anError |
			Rudesheim OpenCL Native Error SetKernelArgumentFailed
				signalForCause:		anError
				kernel:				self
				argumentIndex:		anIndexInteger
				argumentValue:		aCLValue.
		].

]

{ #category : 'accessing' }
KernelOpenCLRudesheim >> defaultParameterTypes [

	^ Array empty.

]

{ #category : 'accessing' }
KernelOpenCLRudesheim >> parameterTypes [

	^ parameterTypes
		ifNil:
		[
			parameterTypes := self defaultParameterTypes.
		].

]

{ #category : 'accessing' }
KernelOpenCLRudesheim >> parameterTypes:	aCTypeSequencialCollection [

	parameterTypes := aCTypeSequencialCollection
]

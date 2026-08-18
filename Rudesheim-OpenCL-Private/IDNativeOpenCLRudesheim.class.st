Class {
	#name : 'IDNativeOpenCLRudesheim',
	#superclass : 'Object',
	#traits : 'TShouldntNewRudesheim',
	#classTraits : 'TShouldntNewRudesheim classTrait',
	#instVars : [
		'idPointer'
	],
	#category : 'Rudesheim-OpenCL-Private-Native',
	#package : 'Rudesheim-OpenCL-Private',
	#tag : 'Native'
}

{ #category : 'enumerating' }
IDNativeOpenCLRudesheim class >> onDo:	aBlock [
	|
		pointer
		uint32
		expectedAmount
		actualAmount
		actualIDs
	|

	pointer := TFBasicType pointer.
	uint32 := TFBasicType uint32.

	expectedAmount := 16r100.

	actualAmount :=
		ExternalAddress
			gcallocate: uint32 byteSize.

	actualIDs :=
		ExternalAddress
			gcallocate: pointer byteSize * expectedAmount.

	Rudesheim OpenCL Native Error Primitive
		shouldZero:
		[
			aBlock
				value:	expectedAmount
				value:	actualIDs
				value:	actualAmount.
		].

	^
	(
		1
			to:
			(
				uint32
					readValue: actualAmount
			)
	)
		collect:
		[ :each |

			super new
				setID:
				(
					pointer
						readValue:	actualIDs
						offset:		1 + ( ( each - 1 ) * pointer byteSize )
				);
				yourself.

		].

]

{ #category : 'accessing' }
IDNativeOpenCLRudesheim >> idPointer [

	^ idPointer
]

{ #category : 'initialization' }
IDNativeOpenCLRudesheim >> setID: aPointer [
	super initialize.
	
	idPointer := aPointer.
]

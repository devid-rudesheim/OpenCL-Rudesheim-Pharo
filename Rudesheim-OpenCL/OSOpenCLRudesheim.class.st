"
Default/base execution detail for the OpenCL two-stage compile/link API, reached as `Smalltalk os rudesheim openCL` or, for reflective discovery, `Rudesheim OpenCL OS`. Performs the real clCompileProgram/clLinkProgram FFI calls. MacOSOpenCLRudesheim overrides both to avoid ever calling the native functions on this platform (see its comment).
"
Class {
	#name : 'OSOpenCLRudesheim',
	#superclass : 'Object',
	#category : 'Rudesheim-OpenCL-OS',
	#package : 'Rudesheim-OpenCL',
	#tag : 'OS'
}

{ #category : 'namespace' }
OSOpenCLRudesheim class >> Mac [
	^ MacOSOpenCLRudesheim.
]

{ #category : 'invoking' }
OSOpenCLRudesheim class >> invokeCompileProgram:	aProgramOpenCLRudesheim
for:					aCLDevicesCollection
withOptions:			anOptionsString
headers:				aHeaderAssociationsCollection
of:						aCLContext [
	|
		functions
		pointer
		deviceIDs
		inputHeaders
		headerIncludeNames
	|

	pointer := TFBasicType pointer.
	functions := Rudesheim OpenCL Native Functions.

	deviceIDs :=
		ExternalAddress
			gcallocate: pointer byteSize * aCLDevicesCollection size.

	aCLDevicesCollection
		withIndexDo:
		[ :each :index |
			deviceIDs
				pointerAt:	index
				put: 		each idPointer tfPointerAddress.
		].

	inputHeaders :=
		aHeaderAssociationsCollection
			ifEmpty:
			[
				ExternalAddress null.
			]
			ifNotEmpty:
			[
				| addresses |
				addresses :=
					ExternalAddress
						gcallocate: pointer byteSize * aHeaderAssociationsCollection size.
				aHeaderAssociationsCollection
					withIndexDo:
					[ :each :index |
						addresses
							pointerAt:	index
							put: 		each value handlePointer tfPointerAddress.
					].
				addresses.
			].

	headerIncludeNames :=
		aHeaderAssociationsCollection
			ifEmpty:
			[
				ExternalAddress null.
			]
			ifNotEmpty:
			[
				| addresses |
				addresses :=
					ExternalAddress
						gcallocate: pointer byteSize * aHeaderAssociationsCollection size.
				aHeaderAssociationsCollection
					withIndexDo:
					[ :each :index |
						addresses
							pointerAt:	index
							put: 		each key utf8Encoded tfPointerAddress.
					].
				addresses.
			].

	^ aCLContext tfRunner
		invokeFunction:	functions functionOfCompileProgram
		withArguments:
		{
			aProgramOpenCLRudesheim handlePointer.
			aCLDevicesCollection size.
			deviceIDs.
			anOptionsString utf8Encoded tfPointerAddress.
			aHeaderAssociationsCollection size.
			inputHeaders.
			headerIncludeNames.
			ExternalAddress null.
			ExternalAddress null.
		}.
]

{ #category : 'invoking' }
OSOpenCLRudesheim class >> invokeLinkProgramFor:	aCLContext
devices:				aCLDevicesCollection
programs:				aProgramsCollection
options:				anOptionsString
errorOutput:			errorOutput [
	|
		functions
		pointer
		deviceIDs
		programHandles
	|

	pointer := TFBasicType pointer.
	functions := Rudesheim OpenCL Native Functions.

	deviceIDs :=
		ExternalAddress
			gcallocate: pointer byteSize * aCLDevicesCollection size.

	aCLDevicesCollection
		withIndexDo:
		[ :each :index |
			deviceIDs
				pointerAt:	index
				put: 		each idPointer tfPointerAddress.
		].

	programHandles :=
		ExternalAddress
			gcallocate: pointer byteSize * aProgramsCollection size.

	aProgramsCollection
		withIndexDo:
		[ :each :index |
			programHandles
				pointerAt:	index
				put: 		each handlePointer tfPointerAddress.
		].

	^ aCLContext tfRunner
		invokeFunction:	functions functionOfLinkProgram
		withArguments:
		{
			aCLContext handlePointer.
			aCLDevicesCollection size.
			deviceIDs.
			anOptionsString utf8Encoded tfPointerAddress.
			aProgramsCollection size.
			programHandles.
			ExternalAddress null.
			ExternalAddress null.
			errorOutput.
		}.
]

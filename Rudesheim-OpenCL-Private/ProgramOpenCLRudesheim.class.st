Class {
	#name : 'ProgramOpenCLRudesheim',
	#superclass : 'HandleNativeOpenCLRudesheim',
	#category : 'Rudesheim-OpenCL-Private-Objects',
	#package : 'Rudesheim-OpenCL-Private',
	#tag : 'Objects'
}

{ #category : 'instance creation' }
ProgramOpenCLRudesheim class >> buildCLProgramFor:	aCLDevicesCollection
fromSources:		aStringCollection
withOptions:		anOptionsString
of:					aCLContext [
	|
		cl
		object
		strings
		deviceIDs
		functions
		pointer
		uint32
	|

	pointer := TFBasicType pointer.
	uint32 := TFBasicType uint32.

	strings :=
		ExternalAddress
			gcallocate: pointer byteSize * aStringCollection size.

	aStringCollection
		withIndexDo:
		[ :each :index |
			strings
				pointerAt: 	index
				put: 		each utf8Encoded tfPointerAddress.
		].

	object :=
		[
			super
				newWithArguments:
				{
					aCLContext handlePointer.
					aStringCollection size.
					strings.
					ExternalAddress null.
				}
		]
			on: PrimitiveErrorNativeOpenCLRudesheim
			do:
			[ :anError |
				Rudesheim OpenCL Native Error ProgramCreationFailed
					signalForCause:	anError
					context:			aCLContext
					sources:			aStringCollection.
			].

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

	cl := Rudesheim OpenCL.
	functions := cl Native Functions.

	[
		cl Native Error Primitive
			shouldZero:
			[
				aCLContext tfRunner
					invokeFunction:	functions functionOfBuildProgram
					withArguments:
					{
						object handlePointer.
						aCLDevicesCollection size.
						deviceIDs.
						anOptionsString utf8Encoded tfPointerAddress.
						ExternalAddress null.
						ExternalAddress null.
					}.
			].
	]
		on: PrimitiveErrorNativeOpenCLRudesheim
		do:
		[ :anError |
			Rudesheim OpenCL Native Error ProgramBuildFailed
				signalForCause:	anError
				program:			object
				devices:			aCLDevicesCollection
				options:			anOptionsString
				buildLog:		(object buildLogFor: aCLDevicesCollection first).
		].

	^ object.
]

{ #category : 'instance creation' }
ProgramOpenCLRudesheim class >> clProgramByLinking:	aProgramsCollection
for:					aCLDevicesCollection
withOptions:			anOptionsString
of:						aCLContext [

	^
	[
		self
			onDo:
			[ :errorOutput |
				( Smalltalk os rudesheim openCL )
					invokeLinkProgramFor:	aCLContext
					devices:				aCLDevicesCollection
					programs:				aProgramsCollection
					options:				anOptionsString
					errorOutput:			errorOutput.
			].
	]
		on: PrimitiveErrorNativeOpenCLRudesheim
		do:
		[ :anError |
			Rudesheim OpenCL Native Error ProgramLinkFailed
				signalForCause:	anError
				context:			aCLContext
				devices:			aCLDevicesCollection
				programs:		aProgramsCollection
				options:			anOptionsString
				buildLog:		'(link failed; no build log available)'.
		].
]

{ #category : 'instance creation' }
ProgramOpenCLRudesheim class >> clProgramWithSources:	aStringCollection
of:						aCLContext [
	|
		strings
		pointer
		uint32
	|

	pointer := TFBasicType pointer.
	uint32 := TFBasicType uint32.

	strings :=
		ExternalAddress
			gcallocate: pointer byteSize * aStringCollection size.

	aStringCollection
		withIndexDo:
		[ :each :index |
			strings
				pointerAt: 	index
				put: 		each utf8Encoded tfPointerAddress.
		].

	^
	[
		super
			newWithArguments:
			{
				aCLContext handlePointer.
				aStringCollection size.
				strings.
				ExternalAddress null.
			}
	]
		on: PrimitiveErrorNativeOpenCLRudesheim
		do:
		[ :anError |
			Rudesheim OpenCL Native Error ProgramCreationFailed
				signalForCause:	anError
				context:			aCLContext
				sources:			aStringCollection.
		].

]

{ #category : 'instance creation' }
ProgramOpenCLRudesheim class >> compileCLProgramFor:	aCLDevicesCollection
fromSources:		aStringCollection
withOptions:		anOptionsString
headers:			aHeaderAssociationsCollection
of:					aCLContext [
	|
		cl
		object
		strings
		pointer
	|

	pointer := TFBasicType pointer.

	strings :=
		ExternalAddress
			gcallocate: pointer byteSize * aStringCollection size.

	aStringCollection
		withIndexDo:
		[ :each :index |
			strings
				pointerAt: 	index
				put: 		each utf8Encoded tfPointerAddress.
		].

	object :=
		[
			super
				newWithArguments:
				{
					aCLContext handlePointer.
					aStringCollection size.
					strings.
					ExternalAddress null.
				}
		]
			on: PrimitiveErrorNativeOpenCLRudesheim
			do:
			[ :anError |
				Rudesheim OpenCL Native Error ProgramCreationFailed
					signalForCause:	anError
					context:			aCLContext
					sources:			aStringCollection.
			].

	cl := Rudesheim OpenCL.

	[
		cl Native Error Primitive
			shouldZero:
			[
				( Smalltalk os rudesheim openCL )
					invokeCompileProgram:	object
					for:					aCLDevicesCollection
					withOptions:			anOptionsString
					headers:				aHeaderAssociationsCollection
					of:						aCLContext.
			].
	]
		on: PrimitiveErrorNativeOpenCLRudesheim
		do:
		[ :anError |
			Rudesheim OpenCL Native Error ProgramCompileFailed
				signalForCause:	anError
				program:			object
				devices:			aCLDevicesCollection
				options:			anOptionsString
				headers:			aHeaderAssociationsCollection
				buildLog:		(object buildLogFor: aCLDevicesCollection first).
		].

	^ object.
]

{ #category : 'accessing' }
ProgramOpenCLRudesheim class >> functionsOfCreationAndRelease [

	^ Rudesheim OpenCL Native Functions functionsOfProgram.
]

{ #category : 'instance creation' }
ProgramOpenCLRudesheim class >> newWithArguments:	aArgumentsSequencialCollection [
	
	^ self shouldNotImplement.
]

{ #category : 'accessing' }
ProgramOpenCLRudesheim >> buildLogFor:	aCLDevice [
	|
		functions
		sizeT
		sizeOutput
		logSize
		logBuffer
	|

	functions := Rudesheim OpenCL Native Functions.
	sizeT := TFBasicType sizeT.
	sizeOutput := ExternalAddress gcallocate: sizeT byteSize.

	^
	[
		functions tfRunner
			invokeFunction:	functions functionOfGetProgramBuildInfo
			withArguments:
			{
				self handlePointer.
				aCLDevice idPointer.
				Rudesheim OpenCL BuildLog clProgramBuildInfo.
				0.
				ExternalAddress null.
				sizeOutput.
			}.

		logSize := sizeT readValue: sizeOutput.
		logBuffer := ExternalAddress gcallocate: logSize.

		functions tfRunner
			invokeFunction:	functions functionOfGetProgramBuildInfo
			withArguments:
			{
				self handlePointer.
				aCLDevice idPointer.
				Rudesheim OpenCL BuildLog clProgramBuildInfo.
				logSize.
				logBuffer.
				ExternalAddress null.
			}.

		logBuffer utf8StringFromCString.
	]
		on: Error
		do:
		[ :anError |
			'(build log unavailable: ', anError messageText, ')'.
		].
]

{ #category : 'instance creation' }
ProgramOpenCLRudesheim >> newCLKernelAt:			aNameString
withParameterTypes:	aCTypeSequencialCollection [

	^ Rudesheim OpenCL Kernel
		clKernelAt:				aNameString
		withParameterTypes: 	aCTypeSequencialCollection
		of: 					self.
]

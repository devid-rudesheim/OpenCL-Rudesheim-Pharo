Class {
	#name : 'KernelCreationFailedOpenCLRudesheim',
	#superclass : 'DetailedPrimitiveErrorNativeOpenCLRudesheim',
	#instVars : [
		'kernelName',
		'parameterTypes',
		'program'
	],
	#category : 'Rudesheim-OpenCL-Private-Errors-Creation',
	#package : 'Rudesheim-OpenCL-Private',
	#tag : 'Errors-Creation'
}

{ #category : 'instance creation' }
KernelCreationFailedOpenCLRudesheim class >> signalForCause:	aPrimitiveErrorNativeOpenCLRudesheim
kernelName:			aNameString
parameterTypes:		aCTypeSequencialCollection
program:				aProgramOpenCLRudesheim [

	^ self basicNew
		signalForCause:	aPrimitiveErrorNativeOpenCLRudesheim
		kernelName:			aNameString
		parameterTypes:		aCTypeSequencialCollection
		program:				aProgramOpenCLRudesheim.

]

{ #category : 'accessing' }
KernelCreationFailedOpenCLRudesheim >> contextDescription [

	^ 'creating kernel ''', self kernelName, ''' on ', self program printString.

]

{ #category : 'accessing' }
KernelCreationFailedOpenCLRudesheim >> kernelName [

	^ kernelName.

]

{ #category : 'accessing' }
KernelCreationFailedOpenCLRudesheim >> kernelName: aNameString [

	kernelName := aNameString.

]

{ #category : 'accessing' }
KernelCreationFailedOpenCLRudesheim >> parameterTypes [

	^ parameterTypes.

]

{ #category : 'accessing' }
KernelCreationFailedOpenCLRudesheim >> parameterTypes: aCTypeSequencialCollection [

	parameterTypes := aCTypeSequencialCollection.

]

{ #category : 'accessing' }
KernelCreationFailedOpenCLRudesheim >> program [

	^ program.

]

{ #category : 'accessing' }
KernelCreationFailedOpenCLRudesheim >> program: aProgramOpenCLRudesheim [

	program := aProgramOpenCLRudesheim.

]

{ #category : 'signaling' }
KernelCreationFailedOpenCLRudesheim >> signalForCause:	aPrimitiveErrorNativeOpenCLRudesheim
kernelName:			aNameString
parameterTypes:		aCTypeSequencialCollection
program:				aProgramOpenCLRudesheim [

	self
		cause:				aPrimitiveErrorNativeOpenCLRudesheim;
		kernelName:			aNameString;
		parameterTypes:		aCTypeSequencialCollection;
		program:				aProgramOpenCLRudesheim.

	^ super signal.

]

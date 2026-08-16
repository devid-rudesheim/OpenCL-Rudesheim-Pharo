"
Default/base OS-specific assertion for the ""...NotSupportedOnMac"" family of tests, reached as
`Smalltalk os rudesheim openCLTestAsserter`. On every OS other than macOS, clCompileProgram/
clLinkProgram aren't known to be unsupported - the underlying OpenCL implementation gets to
decide for itself whether the operation succeeds or fails, and either outcome is acceptable
here since this test isn't about *this* OS's behavior. MacOSAsserterOpenCLRudesheimTest
overrides this to actually assert the mac-specific NotSupported error and message.
"
Class {
	#name : 'OSAsserterOpenCLRudesheimTest',
	#superclass : 'Object',
	#category : 'Rudesheim-OpenCL-Private-Tests-Objects',
	#package : 'Rudesheim-OpenCL-Private-Tests',
	#tag : 'Objects'
}

{ #category : 'asserting' }
OSAsserterOpenCLRudesheimTest class >> for:			aTestCase
should:				aBlock
raiseCompileOrLinkError:	aNotSupportedExceptionClass [

	[
		aBlock value.
	]
		on: Error
		do:
		[ :anError |
			"Some native failure is an acceptable outcome here too - this OS just isn't
			known to reject the operation outright the way macOS does."
		].
]

"
macOS-specific assertion for the ""...NotSupportedOnMac"" family of tests, reached as
`Smalltalk os rudesheim openCLTestAsserter` on a Mac. Overrides OSAsserterOpenCLRudesheimTest
(its superclass) to actually assert that the mac-specific NotSupported error is raised, with
the standard 'not supported on this platform' message - see MacOSOpenCLRudesheim's comment for
why compiling/linking are unsupported on this platform's OpenCL implementation.
"
Class {
	#name : 'MacOSAsserterOpenCLRudesheimTest',
	#superclass : 'OSAsserterOpenCLRudesheimTest',
	#category : 'Rudesheim-OpenCL-Private-Tests-Objects',
	#package : 'Rudesheim-OpenCL-Private-Tests',
	#tag : 'Objects'
}

{ #category : 'asserting' }
MacOSAsserterOpenCLRudesheimTest class >> for:			aTestCase
should:				aBlock
raiseCompileOrLinkError:	aNotSupportedExceptionClass [

	aTestCase
		should:			aBlock
		raise:			aNotSupportedExceptionClass
		whoseDescriptionIncludes:	'not supported on this platform'
		description:	aNotSupportedExceptionClass name, ' with ''not supported on this platform'' in its message'.
]

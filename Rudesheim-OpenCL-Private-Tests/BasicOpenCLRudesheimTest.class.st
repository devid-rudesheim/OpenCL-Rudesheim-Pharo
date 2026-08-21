"
A BasicOpenCLRudesheimTest is the shared superclass for OpenCL test cases that need to build a
CL program - it centralizes the `-cl-std=` build option so every test targets the same OpenCL C
language version.

It also tracks every native OpenCL handle (CommandQueue/Context/Program/Kernel/Event/Buffer)
created via #trackForRelease: and releases them all in #tearDown, instead of leaving their
native release to GC finalization. Letting finalization pile up a burst of clRelease* calls
across many freshly-GC-unreachable handles was found to race with Apple's cl2Metal bridge and
crash the VM natively (SIGSEGV inside clCreateCommandQueueWithPropertiesAPPLE/clFinish) once the
image is long-lived enough for finalizers to actually run -- see
note/opencl-commandqueue-crash-investigation.md.
"
Class {
	#name : 'BasicOpenCLRudesheimTest',
	#superclass : 'BasicRudesheimTest',
	#instVars : [
		'resourcesForRelease'
	],
	#category : 'Rudesheim-OpenCL-Private-Tests-Objects',
	#package : 'Rudesheim-OpenCL-Private-Tests',
	#tag : 'Objects'
}

{ #category : 'accessing' }
BasicOpenCLRudesheimTest class >> isAbstract [
	^ self = BasicOpenCLRudesheimTest.
]

{ #category : 'accessing' }
BasicOpenCLRudesheimTest >> defaultCLStdOption [

	^ '-cl-std=CL3.0'
]

{ #category : 'accessing' }
BasicOpenCLRudesheimTest >> defaultResourcesForRelease [

	^ OrderedCollection new.
]

{ #category : 'accessing' }
BasicOpenCLRudesheimTest >> resourcesForRelease [

	^ resourcesForRelease
		ifNil:
		[
			resourcesForRelease := self defaultResourcesForRelease.
		].

]

{ #category : 'releasing' }
BasicOpenCLRudesheimTest >> trackForRelease: aHandleNativeOpenCLRudesheim [
	"Register a freshly created native OpenCL handle so #tearDown releases it
	deterministically, instead of leaving its native release to GC
	finalization. Returns aHandleNativeOpenCLRudesheim, so creation call sites
	can wrap the creation expression inline."

	self resourcesForRelease add: aHandleNativeOpenCLRudesheim.

	^ aHandleNativeOpenCLRudesheim.
]

{ #category : 'running' }
BasicOpenCLRudesheimTest >> tearDown [

	self resourcesForRelease
		do:
		[ :each |
			each releaseRudesheim.
		].

	super tearDown.
]

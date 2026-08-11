Class {
	#name : 'DeviceOpenCLRudesheimTest',
	#superclass : 'BasicRudesheimTest',
	#category : 'Rudesheim-OpenCL-Private-Tests-Objects',
	#package : 'Rudesheim-OpenCL-Private-Tests',
	#tag : 'Objects'
}

{ #category : 'accessing' }
DeviceOpenCLRudesheimTest class >> targetClass [

	^ DeviceOpenCLRudesheim.
]

{ #category : 'tests' }
DeviceOpenCLRudesheimTest >> runCLDevicesForTypeOf0 [
	
	self
		assert:
		[
			0 <
			(
				self targetClass
					clDevicesForType:	self sourceValue
					of:					Rudesheim OpenCL Platform clPlatforms first
			) size.
		].
]

{ #category : 'tests' }
DeviceOpenCLRudesheimTest >> testCLDevicesForTypeOf [
	
	self
		testCLDevicesForTypeOf0_0.
]

{ #category : 'tests' }
DeviceOpenCLRudesheimTest >> testCLDevicesForTypeOf0_0 [
	
	self
		sourceValue:
		(
			{
				Rudesheim OpenCL All
			}
		);
		runCLDevicesForTypeOf0.
]

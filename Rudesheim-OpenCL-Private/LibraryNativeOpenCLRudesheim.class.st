Class {
	#name : 'LibraryNativeOpenCLRudesheim',
	#superclass : 'FFILibrary',
	#category : 'Rudesheim-OpenCL-Private-Native',
	#package : 'Rudesheim-OpenCL-Private',
	#tag : 'Native'
}

{ #category : 'accessing - platform' }
LibraryNativeOpenCLRudesheim >> macLibraryName [

	^ ( FileLocator root / 'System/Library/Frameworks/OpenCL.framework/Versions/A/OpenCL' ) pathString
]

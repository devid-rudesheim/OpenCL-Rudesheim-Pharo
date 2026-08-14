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

{ #category : 'accessing - platform' }
LibraryNativeOpenCLRudesheim >> unix32LibraryName [

	(#( '/usr/lib/i386-linux-gnu' '/usr/lib32' '/usr/lib' ),
			((OSEnvironment current at: 'LD_LIBRARY_PATH' ifAbsent: [ '' ]) substrings: ':'))
		do:
		[ :path |
			#( 'libOpenCL.so.1' 'libOpenCL.so' )
				do:
				[ :libraryName |
					| libraryPath |
					libraryPath := path asFileReference / libraryName.
					libraryPath exists
						ifTrue: [ ^ libraryPath fullName ]
				]
		].
	self error: 'Module not found.'
]

{ #category : 'accessing - platform' }
LibraryNativeOpenCLRudesheim >> unix64LibraryName [

	(#( '/usr/lib/x86_64-linux-gnu' '/lib/x86_64-linux-gnu' '/usr/lib64' '/usr/lib' ),
			((OSEnvironment current at: 'LD_LIBRARY_PATH' ifAbsent: [ '' ]) substrings: ':'))
		do:
		[ :path |
			#( 'libOpenCL.so.1' 'libOpenCL.so' )
				do:
				[ :libraryName |
					| libraryPath |
					libraryPath := path asFileReference / libraryName.
					libraryPath exists
						ifTrue: [ ^ libraryPath fullName ]
				]
		].
	self error: 'Module not found.'
]

{ #category : 'accessing - platform' }
LibraryNativeOpenCLRudesheim >> win32LibraryName [

	^ FFIWindowsLibraryFinder findLibrary: 'OpenCL.dll'
]

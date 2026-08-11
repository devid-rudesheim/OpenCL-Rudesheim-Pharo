Extension { #name : 'FFIExternalResourceManager' }

{ #category : '*Rudesheim-OpenCL-Private' }
FFIExternalResourceManager >> removeResource: anObject [

	registry remove: anObject ifAbsent: [ ]
]

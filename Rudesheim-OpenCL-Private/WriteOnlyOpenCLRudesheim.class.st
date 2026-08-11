Class {
	#name : 'WriteOnlyOpenCLRudesheim',
	#superclass : 'Object',
	#traits : 'TBufferDefineOpenCLRudesheim + TMapDefineOpenCLRudesheim',
	#classTraits : 'TBufferDefineOpenCLRudesheim classTrait + TMapDefineOpenCLRudesheim classTrait',
	#category : 'Rudesheim-OpenCL-Private-Defines-Buffer',
	#package : 'Rudesheim-OpenCL-Private',
	#tag : 'Defines-Buffer'
}

{ #category : 'accessing' }
WriteOnlyOpenCLRudesheim class >> offsetOfCLBufferType [

	^ 1
]

{ #category : 'accessing' }
WriteOnlyOpenCLRudesheim class >> offsetOfCLMapType [

	^ 1
]

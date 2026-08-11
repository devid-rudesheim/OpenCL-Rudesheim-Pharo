Class {
	#name : 'ReadOnlyOpenCLRudesheim',
	#superclass : 'Object',
	#traits : 'TBufferDefineOpenCLRudesheim + TMapDefineOpenCLRudesheim',
	#classTraits : 'TBufferDefineOpenCLRudesheim classTrait + TMapDefineOpenCLRudesheim classTrait',
	#category : 'Rudesheim-OpenCL-Private-Defines-Buffer',
	#package : 'Rudesheim-OpenCL-Private',
	#tag : 'Defines-Buffer'
}

{ #category : 'accessing' }
ReadOnlyOpenCLRudesheim class >> offsetOfCLBufferType [

	^ 2
]

{ #category : 'accessing' }
ReadOnlyOpenCLRudesheim class >> offsetOfCLMapType [

	^ 0
]

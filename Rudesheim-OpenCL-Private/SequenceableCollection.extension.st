Extension { #name : 'SequenceableCollection' }

{ #category : '*Rudesheim-OpenCL-Private' }
SequenceableCollection >> asOpenCLBufferRudesheim: aContextOpenCLRudesheim [
	"Uploads this collection as a fresh OpenCL buffer. Counterpart to
	BufferOpenCLRudesheim>>asOpenCLBufferRudesheim:, which is a same-context
	no-op -- together they let a Layer forward: upload only when its input
	isn't already an OpenCL buffer. See
	note/opencl-layer-buffer-passthrough-design.md."

	^ (aContextOpenCLRudesheim newCLBufferWithFloats: self)
		count: self size;
		yourself
]

{ #category : '*Rudesheim-OpenCL-Private' }
SequenceableCollection >> rudesheimConcatenatedWith: anotherValue [
	"Plain-Array-side counterpart to BufferOpenCLRudesheim>>rudesheimConcatenatedWith:
	-- self already being a plain Array (not a live OpenCL buffer) means there is no
	GPU buffer identity worth preserving, so this just concatenates. anotherValue
	asArray downloads it first if it's a live OpenCL buffer (a no-op if it's already
	a plain Array)."

	^ self , anotherValue asArray
]

{ #category : '*Rudesheim-OpenCL-Private' }
SequenceableCollection >> releaseRudesheim [
	"No-op counterpart to BufferOpenCLRudesheim>>releaseRudesheim -- lets code
	that may be holding either a plain Array or a BufferOpenCLRudesheim
	release unconditionally without a kind check."

	^ self
]

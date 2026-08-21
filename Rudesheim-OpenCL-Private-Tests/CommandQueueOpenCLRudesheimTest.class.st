"
A CommandQueueOpenCLRudesheimTest is a test class for testing the behavior of CommandQueueOpenCLRudesheim
"
Class {
	#name : 'CommandQueueOpenCLRudesheimTest',
	#superclass : 'BasicOpenCLRudesheimTest',
	#instVars : [
		'clDevices',
		'clContext',
		'clProgram'
	],
	#category : 'Rudesheim-OpenCL-Private-Tests-Objects',
	#package : 'Rudesheim-OpenCL-Private-Tests',
	#tag : 'Objects'
}

{ #category : 'accessing' }
CommandQueueOpenCLRudesheimTest class >> targetClass [

	^ CommandQueueOpenCLRudesheim.
]

{ #category : 'accessing' }
CommandQueueOpenCLRudesheimTest >> clContext [

	^ clContext
		ifNil:
		[
			clContext := self defaultCLContext.
		].

]

{ #category : 'accessing' }
CommandQueueOpenCLRudesheimTest >> clContext: aContextOpenCLRudesheim [

	clContext := aContextOpenCLRudesheim.
]

{ #category : 'accessing' }
CommandQueueOpenCLRudesheimTest >> clDevices [

	^ clDevices
		ifNil:
		[
			clDevices := self defaultCLDevices.
		].

]

{ #category : 'accessing' }
CommandQueueOpenCLRudesheimTest >> clProgram [

	^ clProgram
		ifNil:
		[
			clProgram := self defaultCLProgram.
		].

]

{ #category : 'accessing' }
CommandQueueOpenCLRudesheimTest >> clProgram: aProgramOpenCLRudesheim [

	clProgram := aProgramOpenCLRudesheim.
]

{ #category : 'running' }
CommandQueueOpenCLRudesheimTest >> tearDown [
	"Some composite test methods (e.g. testEnqueueFillByPatternForRangeForWait)
	call #tearDown/#setUp mid-method to run several run*/test*0_n phases in a
	row. #setUp (inherited) never resets clContext/clProgram, so without this
	override a later phase would keep using the already-released (by
	super tearDown, via BasicOpenCLRudesheimTest's trackForRelease:
	bookkeeping) native handle instead of getting a fresh one."

	self
		clContext:	nil;
		clProgram:	nil.

	super tearDown.
]

{ #category : 'accessing' }
CommandQueueOpenCLRudesheimTest >> defaultBasicTarget [

	^ self
		trackForRelease:
		(
			self targetClass
				clCommandQueueFor:	self clDevices first
				of:					self clContext
		).
]

{ #category : 'accessing' }
CommandQueueOpenCLRudesheimTest >> defaultCLContext [

	^ self
		trackForRelease:
		(
			Rudesheim OpenCL Context
				clContextFor:	self clDevices
		).

]

{ #category : 'accessing' }
CommandQueueOpenCLRudesheimTest >> defaultCLDevices [

	^ Rudesheim OpenCL Platform clPlatforms first clDevices.

]

{ #category : 'accessing' }
CommandQueueOpenCLRudesheimTest >> defaultCLProgram [

	^ self
		trackForRelease:
		(
			self clContext
				buildCLProgramFor:	self clDevices
				fromSources:
				{
					'
size_t IndexFromGlobal3IDs()
{
	size_t
		index = get_global_id( 2 );

	for( int i = 1; 0 <= i; --i )
	{
		index *= get_global_size( i );
		index += get_global_id( i );
	}

	return index;
}

kernel void FillBySequence( global unsigned int *output )
{
	size_t
		index = IndexFromGlobal3IDs();

	output[ index ] = index;
}

kernel void Add( global unsigned int *output, global unsigned int const *input0, global unsigned int const *input1 )
{
	size_t
		index = IndexFromGlobal3IDs();

	output[ index ] = input0[ index ] + input1[ index ];
}

kernel void One( global unsigned int *output )
{
	unsigned long
		index = get_local_id( 2 );

	for( int i = 1; 0 <= i; --i )
	{
		index *= get_local_size( i );
		index += get_local_id( i );
	}

	output[ index ] = index;
}

kernel void Two( global unsigned int *output, global unsigned int const *input, unsigned int operand )
{
	size_t
		index = IndexFromGlobal3IDs();

	output[ index ] = operand + input[ index ];
}

kernel void SlowLoopRudesheim( global unsigned int *output, unsigned int iterationCount )
{
	unsigned int state;
	unsigned int index;

	state = 1u;
	for( index = 0; index < iterationCount; index++ )
	{
		state = ( state * 1103515245u ) + 12345u;
	}

	output[ 0 ] = state;
}
				'
			}
			withOptions:		self defaultCLStdOption
		).

]

{ #category : 'tests' }
CommandQueueOpenCLRudesheimTest >> runConcurrentFinishAcrossCommandQueues0 [
	|
		outputBuffer
		slowKernel
		slowQueue
		fastQueue
	|

	outputBuffer :=
		self
			trackForRelease:
			(
				self clContext
					newCLBufferForSize:	TFBasicType uint byteSize
			).

	slowKernel :=
		self
			trackForRelease:
			(
				self clProgram
					newCLKernelAt:	'SlowLoopRudesheim'
					withParameterTypes:
					{
						TFBasicType pointer.
						TFBasicType uint.
					}
			).

	slowQueue :=
		self
			trackForRelease:
			(
				self targetClass
					clCommandQueueFor:	self clDevices first
					of:					self clContext
			).

	fastQueue :=
		self
			trackForRelease:
			(
				self targetClass
					clCommandQueueFor:	self clDevices first
					of:					self clContext
			).

	[
		slowQueue
			enqueueKernel:	slowKernel
			forNDRange:
			{
				{ 16r1. 16r1. 16r1. }
			}
			withArguments:
			{
				outputBuffer.
				16r5F5E100.
			}
			forWait:
			{
			}.

		slowQueue finish.
	]
		fork.

	( Delay forMilliseconds: 16r0C8 ) wait.

	fastQueue finish.

]

{ #category : 'tests' }
CommandQueueOpenCLRudesheimTest >> runEnqueueCopyFromOffsetToForRangeAsForWait1 [
	|
		target
		cl
		input
		copyOutput
		fillKernel
		ouput
	|

	ouput :=
		IntegerArray
			new:	16r04.

	cl := Rudesheim OpenCL.

	target :=
		self
			trackForRelease:
			(
				self targetClass
					clCommandQueueFor:		self clDevices first
					of:						self clContext
			).

	input :=
		self
			trackForRelease:
			(
				self clContext
					newCLBufferForSize: ouput byteSize
			).

	fillKernel :=
		self
			trackForRelease:
			(
				self clProgram
					newCLKernelAt:	'FillBySequence'
					withParameterTypes:
					{
						TFBasicType pointer
					}
			).

	target
		enqueueKernel:	fillKernel
		forNDRange:
		{
			{
				ouput size.
				16r1.
				16r1.
			}
		}
		withArguments:
		{
			input
		}.

	copyOutput :=
		self
			trackForRelease:
			(
				self clContext
					newCLBufferWith:	ouput
			).

	target
		enqueueCopyFrom:	input
		offset: 0
		to:					copyOutput
		forRange:
		(
			1
				to: ouput size
		)
		as:	TFBasicType uint
		forWait:
		{
		}.

	target finish.

	self
		assertCollection:	ouput asArray
		equals: 			#( 0 1 2 3 ).
]

{ #category : 'tests' }
CommandQueueOpenCLRudesheimTest >> runEnqueueFillByPatternForRangeForWait0 [
	|
		target
		cl
		fillBuffer
		ouput
	|

	ouput :=
		IntegerArray
			new:	16r04.

	cl := Rudesheim OpenCL.

	target :=
		self
			trackForRelease:
			(
				self targetClass
					clCommandQueueFor:		self clDevices first
					of:						self clContext
			).

	fillBuffer :=
		self
			trackForRelease:
			(
				self clContext
					newCLBufferWith:	ouput
			).

	target
		enqueueFill:	fillBuffer
		byPattern: #( 1 ) asIntegerArray
		forRange:	self sourceValue
		forWait:
		{
		}.

	target finish.

	self
		assertCollection:	ouput asArray
		equals: 			#( 0 1 1 0 ).
]

{ #category : 'tests' }
CommandQueueOpenCLRudesheimTest >> runEnqueueFillByPatternForRangeForWait1 [
	|
		target
		cl
		fillBuffer
		ouput
	|

	ouput :=
		IntegerArray
			new:	16r04.

	cl := Rudesheim OpenCL.

	target :=
		self
			trackForRelease:
			(
				self targetClass
					clCommandQueueFor:		self clDevices first
					of:						self clContext
			).

	fillBuffer :=
		self
			trackForRelease:
			(
				self clContext
					newCLBufferWith:	ouput
			).

	target
		enqueueFill:	fillBuffer
		byPattern: #( 1 ) asIntegerArray
		forRange:
		(
			2
				to:	3
		)
		forWait:
		{
		}.

	target finish.

	self
		assertCollection:	ouput asArray
		equals: 			#( 0 1 1 0 ).
]

{ #category : 'tests' }
CommandQueueOpenCLRudesheimTest >> runEnqueueKernelForNDRangeWithArgumentsForWait1 [
	|
		target
		cl
		ndRange
		fillKernel
		kernelOutput
		ouput
		lengthOfGlobalRange
	|

	ndRange :=
	{
		#( 2 4 8 ).
	}.

	lengthOfGlobalRange :=
		ndRange first
			fold:
			[ :left :right |
				left * right
			].

	ouput :=
		IntegerArray
			new:	lengthOfGlobalRange.

	cl := Rudesheim OpenCL.

	target :=
		self
			trackForRelease:
			(
				self targetClass
					clCommandQueueFor:		self clDevices first
					of:						self clContext
			).

	fillKernel :=
		self
			trackForRelease:
			(
				self clProgram
					newCLKernelAt:	'FillBySequence'
					withParameterTypes:
					{
						TFBasicType pointer
					}
			).

	kernelOutput :=
		self
			trackForRelease:
			(
				self clContext
					newCLBufferWith:	ouput
			).

	target
		enqueueKernel:	fillKernel
		forNDRange:	ndRange
		withArguments:
		{
			kernelOutput
		}
		forWait:
		{
		}.

	target finish.

	self
		assertCollection:	ouput asArray
		equals:
		(
			0
				to:	lengthOfGlobalRange - 1
		) asArray.
]

{ #category : 'tests' }
CommandQueueOpenCLRudesheimTest >> runEnqueueKernelForNDRangeWithArgumentsForWait2 [
	|
		target
		cl
		ndRange
		oneKernel
		kernelOutput
		ouput
		lengthOfGlobalRange
		baseRange
	|

	baseRange := #( 2 4 8 ).
	ndRange :=
	{
		baseRange.
		baseRange
	}.

	lengthOfGlobalRange :=
		ndRange first
			fold:
			[ :left :right |
				left * right
			].

	ouput :=
		IntegerArray
			new:	lengthOfGlobalRange.

	cl := Rudesheim OpenCL.

	target :=
		self
			trackForRelease:
			(
				self targetClass
					clCommandQueueFor:		self clDevices first
					of:						self clContext
			).

	oneKernel :=
		self
			trackForRelease:
			(
				self clProgram
					newCLKernelAt:	'One'
					withParameterTypes:
					{
						TFBasicType pointer
					}
			).

	kernelOutput :=
		self
			trackForRelease:
			(
				self clContext
					newCLBufferWith:	ouput
			).

	target
		enqueueKernel:	oneKernel
		forNDRange:	ndRange
		withArguments:
		{
			kernelOutput
		}
		forWait:
		{
		}.

	target finish.

	self
		assertCollection:	ouput asArray
		equals:
		(
			0
				to:	lengthOfGlobalRange - 1
		) asArray.
]

{ #category : 'tests' }
CommandQueueOpenCLRudesheimTest >> runEnqueueKernelForNDRangeWithArgumentsForWait3 [
	|
		target
		cl
		ndRange
		ouput
		buffers
		lengthOfGlobalRange
		accumulate
		addKernel
		addOutput
		eventOfTrigger
		eventOfBegin
		eventOfBranch
		eventOfEnd
	|

	ndRange :=
	{
		#( 2 4 8 ).
	}.

	lengthOfGlobalRange :=
		ndRange first
			fold:
			[ :left :right |
				left * right
			].

	ouput :=
		IntegerArray
			new:	lengthOfGlobalRange.

	cl := Rudesheim OpenCL.

	buffers :=
	(
		1
			to: 4
	)
		collect:
		[ :each |
				self clContext
					newCLBufferForSize: ouput byteSize.
		].

	buffers
		do:
		[ :each |
			self trackForRelease: each.
		].

	eventOfTrigger :=
		self trackForRelease: self clContext newCLEvent.

	target :=
		self
			trackForRelease:
			(
				self targetClass
					clCommandQueueFor:		self clDevices first
					of:						self clContext
			).

	accumulate :=
		self
			trackForRelease:
			(
				self clProgram
					newCLKernelAt:	'Two'
					withParameterTypes:
					{
						TFBasicType pointer.
						TFBasicType pointer.
						TFBasicType uint.
					}
			).

	eventOfBegin :=
		target
			enqueueFill:
			(
				buffers
					at:	1
			)
			byPattern: #( 0 ) asIntegerArray
			forRange:
			(
				1
					to:	lengthOfGlobalRange
			)
			forWait:
			{
				eventOfTrigger
			}.

	eventOfBranch :=
	{
		target
			enqueueKernel:	accumulate
			forNDRange:		ndRange
			withArguments:
			{
				buffers
					at:	2.
				buffers
					at:	1.
				16r01.
			}
			forWait:
			{
				eventOfBegin
			}.

		target
			enqueueKernel:	accumulate
			forNDRange:		ndRange
			withArguments:
			{
				buffers
					at:	3.
				buffers
					at:	1.
				16r02.
			}
			forWait:
			{
				eventOfBegin
			}.
	}.

	addKernel :=
		self
			trackForRelease:
			(
				self clProgram
					newCLKernelAt:	'Add'
					withParameterTypes:
					{
						TFBasicType pointer.
						TFBasicType pointer.
						TFBasicType pointer.
					}
			).

	addOutput :=
		self
			trackForRelease:
			(
				self clContext
					newCLBufferWith:	ouput
			).

	eventOfEnd :=
		target
			enqueueKernel:	addKernel
			forNDRange:		ndRange
			withArguments:
			{
				addOutput.
				buffers
					at:	2.
				buffers
					at:	3.
			}
			forWait:	eventOfBranch.

	eventOfTrigger
		status: 0.

	eventOfEnd wait.

	target finish.

	self
		assertCollection:	ouput asArray
		equals:
		(
			(
				1
					to:	lengthOfGlobalRange
			)
				collect:
				[ :each |
					16r01 + 16r02
				]
				as: Array
		).
]

{ #category : 'tests' }
CommandQueueOpenCLRudesheimTest >> runEnqueueMapForRangeAsOptionsBlockingForWait0 [

	self flag: #toImplement.
	self assert: false
]

{ #category : 'tests' }
CommandQueueOpenCLRudesheimTest >> runEnqueueMapForRangeAsOptionsBlockingForWait1 [
	|
		target
		cl
		mappedArray
		ouput
		tuple
		rawArray
		forWaitEvent
	|

	ouput :=
		IntegerArray
			new:	self sourceValue size.

	cl := Rudesheim OpenCL.

	target :=
		self
			trackForRelease:
			(
				self targetClass
					clCommandQueueFor:		self clDevices first
					of:						self clContext
			).

	mappedArray :=
		self
			trackForRelease:
			(
				self clContext
					newCLBufferWith: ouput
			).

	forWaitEvent :=
		self trackForRelease: self clContext newCLEvent.

	tuple :=
		target
			enqueueMap:		mappedArray
			forRange:
			(
				1
					to: ouput size
			)
			as: 			TFBasicType uint32
			options:
			{
				cl WriteOnly
			}
			blocking:		true
			forWait:
			{

				forWaitEvent
					status:	0;
					yourself

			}.

	rawArray := tuple first.

	self sourceValue
		do:
		[ :each |

			rawArray
				uint32AtOffset:	each * TFBasicType uint byteSize
				put: 				each.

		].

	(
		target
			enqueueUnmap:	tuple first
			of:				mappedArray
			forWait:
			{
				tuple last
			}
	) wait.

	target finish.

	self
		assertCollection:	ouput asArray
		equals: 			self expectedValue.

]

{ #category : 'tests' }
CommandQueueOpenCLRudesheimTest >> runEnqueueMapForRangeAsOptionsBlockingForWaitDo1 [
	|
		target
		cl
		mappedArray
		ouput
		forWaitEvent
	|

	ouput :=
		IntegerArray
			new:	self sourceValue size.

	cl := Rudesheim OpenCL.

	target :=
		self
			trackForRelease:
			(
				self targetClass
					clCommandQueueFor:		self clDevices first
					of:						self clContext
			).

	mappedArray :=
		self
			trackForRelease:
			(
				self clContext
					newCLBufferWith: ouput
			).

	forWaitEvent :=
		self trackForRelease: self clContext newCLEvent.

	(
		target
			enqueueMap:		mappedArray
			forRange:
			(
				1
					to: ouput size
			)
			as: 			TFBasicType uint32
			options:
			{
				cl WriteOnly
			}
			blocking:		true
			forWait:
			{

				forWaitEvent
					status:	0;
					yourself

			}
			do:
			[ :rawArray |

				self sourceValue
					do:
					[ :each |

						rawArray
							uint32AtOffset:	each * TFBasicType uint byteSize
							put: 				each.

					].

			]
	) wait.

	target finish.

	self
		assertCollection:	ouput asArray
		equals: 			self expectedValue.

]

{ #category : 'tests' }
CommandQueueOpenCLRudesheimTest >> testConcurrentFinishAcrossCommandQueues [

	self
		testConcurrentFinishAcrossCommandQueues0_0.

]

{ #category : 'tests' }
CommandQueueOpenCLRudesheimTest >> testConcurrentFinishAcrossCommandQueues0_0 [

	self
		timeLimit: 5 seconds;
		runConcurrentFinishAcrossCommandQueues0.

]

{ #category : 'tests' }
CommandQueueOpenCLRudesheimTest >> testEnqueueCopyFromOffsetToForRangeAsForWait [

	self
		"testEnqueueCopyFromOffsetToForRangeAsForWait0_0;
		tearDown;
		setUp;"
		testEnqueueCopyFromOffsetToForRangeAsForWait1_0.

]

{ #category : 'tests' }
CommandQueueOpenCLRudesheimTest >> testEnqueueCopyFromOffsetToForRangeAsForWait0_0 [

	self skip: 'Placeholder selector; implemented coverage is in testEnqueueCopyFromOffsetToForRangeAsForWait1_0.'.
]

{ #category : 'tests' }
CommandQueueOpenCLRudesheimTest >> testEnqueueCopyFromOffsetToForRangeAsForWait1_0 [

	self
		runEnqueueCopyFromOffsetToForRangeAsForWait1.
]

{ #category : 'tests' }
CommandQueueOpenCLRudesheimTest >> testEnqueueFillByPatternForRangeForWait [

	self
		testEnqueueFillByPatternForRangeForWait0_0;
		tearDown;
		setUp;
		testEnqueueFillByPatternForRangeForWait1_0
]

{ #category : 'tests' }
CommandQueueOpenCLRudesheimTest >> testEnqueueFillByPatternForRangeForWait0_0 [

	self
		should:
		[
			self
				sourceValue:
				(
					16r8
						to: 16r10
				);
				runEnqueueFillByPatternForRangeForWait0
		]
		raise:	Rudesheim OpenCL Native Error Primitive.
]

{ #category : 'tests' }
CommandQueueOpenCLRudesheimTest >> testEnqueueFillByPatternForRangeForWait0_0Detailed [
	|
		caughtError
	|

	caughtError :=
		[
			self
				sourceValue:
				(
					16r8
						to: 16r10
				);
				runEnqueueFillByPatternForRangeForWait0.

			nil.
		]
			on: EnqueueFillFailedOpenCLRudesheim
			do:
			[ :anError |
				anError.
			].

	self
		assert:	caughtError notNil.
	self
		assert:	( caughtError messageText includesSubstring: 'enqueueing a fill' ).
	self
		assert:	( caughtError messageText includesSubstring: 'invalid_value' ).

]

{ #category : 'tests' }
CommandQueueOpenCLRudesheimTest >> testEnqueueFillByPatternForRangeForWait0_1 [

	self
		should:
		[
			self
				sourceValue:
				(
					16r10
						to: 16r1
				);
				runEnqueueFillByPatternForRangeForWait0
		]
		raise:	Rudesheim OpenCL Native Error Primitive.
]

{ #category : 'tests' }
CommandQueueOpenCLRudesheimTest >> testEnqueueFillByPatternForRangeForWait1_0 [

	self
		runEnqueueFillByPatternForRangeForWait1.
]

{ #category : 'tests' }
CommandQueueOpenCLRudesheimTest >> testEnqueueKernelAndWaitForNDRangeWithArguments0_0 [
	|
		target
		fillKernel
		kernelOutput
		ndRange
		ouput
		lengthOfGlobalRange
	|

	ndRange :=
	{
		#( 2 4 8 ).
	}.

	lengthOfGlobalRange :=
		ndRange first
			fold:
			[ :left :right |
				left * right
			].

	ouput :=
		IntegerArray
			new:	lengthOfGlobalRange.

	target :=
		self
			trackForRelease:
			(
				self targetClass
					clCommandQueueFor:		self clDevices first
					of:						self clContext
			).

	fillKernel :=
		self
			trackForRelease:
			(
				self clProgram
					newCLKernelAt:	'FillBySequence'
					withParameterTypes:
					{
						TFBasicType pointer
					}
			).

	kernelOutput :=
		self
			trackForRelease:
			(
				self clContext
					newCLBufferWith:	ouput
			).

	target
		enqueueKernelAndWait:	fillKernel
		forNDRange:	ndRange
		withArguments:
		{
			kernelOutput
		}.

	self
		assertCollection:	ouput asArray
		equals:
		(
			0
				to:	lengthOfGlobalRange - 1
		) asArray.
]

{ #category : 'tests' }
CommandQueueOpenCLRudesheimTest >> testEnqueueKernelForNDRangeWithArgumentsForWait [

	self
		"testEnqueueKernelForNDRangeWithArgumentsForWait0_0;
		tearDown;
		setUp;"
		testEnqueueKernelForNDRangeWithArgumentsForWait1_0;
		tearDown;
		setUp;
		testEnqueueKernelForNDRangeWithArgumentsForWait2_0;
		tearDown;
		setUp;
		testEnqueueKernelForNDRangeWithArgumentsForWait3_0.

]

{ #category : 'tests' }
CommandQueueOpenCLRudesheimTest >> testEnqueueKernelForNDRangeWithArgumentsForWait0_0 [

	self skip: 'Placeholder selector; implemented coverage is in testEnqueueKernelForNDRangeWithArgumentsForWait1_0 and later variants.'.
]

{ #category : 'tests' }
CommandQueueOpenCLRudesheimTest >> testEnqueueKernelForNDRangeWithArgumentsForWait1_0 [

	self
		runEnqueueKernelForNDRangeWithArgumentsForWait1.
]

{ #category : 'tests' }
CommandQueueOpenCLRudesheimTest >> testEnqueueKernelForNDRangeWithArgumentsForWait2_0 [

	self
		runEnqueueKernelForNDRangeWithArgumentsForWait2.
]

{ #category : 'tests' }
CommandQueueOpenCLRudesheimTest >> testEnqueueKernelForNDRangeWithArgumentsForWait3_0 [

	self
		runEnqueueKernelForNDRangeWithArgumentsForWait3.
]

{ #category : 'tests' }
CommandQueueOpenCLRudesheimTest >> testEnqueueMapForRangeAsOptionsBlockingForWait [

	self
		testEnqueueMapForRangeAsOptionsBlockingForWait1_0.
]

{ #category : 'tests' }
CommandQueueOpenCLRudesheimTest >> testEnqueueMapForRangeAsOptionsBlockingForWait0_0 [

	self skip: 'Placeholder selector; implemented coverage is in testEnqueueMapForRangeAsOptionsBlockingForWait1_0.'.
]

{ #category : 'tests' }
CommandQueueOpenCLRudesheimTest >> testEnqueueMapForRangeAsOptionsBlockingForWait1_0 [
	|
		values
	|

	values :=
		0
			to:	3.

	self
		expectedValue:	values;
		sourceValue:	values;
		runEnqueueMapForRangeAsOptionsBlockingForWait1.
]

{ #category : 'tests' }
CommandQueueOpenCLRudesheimTest >> testEnqueueMapForRangeAsOptionsBlockingForWaitDo [

	self
		testEnqueueMapForRangeAsOptionsBlockingForWaitDo1_0.
]

{ #category : 'tests' }
CommandQueueOpenCLRudesheimTest >> testEnqueueMapForRangeAsOptionsBlockingForWaitDo0_0 [

	self skip: 'Placeholder selector; implemented coverage is in testEnqueueMapForRangeAsOptionsBlockingForWaitDo1_0.'.
]

{ #category : 'tests' }
CommandQueueOpenCLRudesheimTest >> testEnqueueMapForRangeAsOptionsBlockingForWaitDo1_0 [
	|
		values
	|

	values :=
		0
			to:	3.

	self
		expectedValue:	values;
		sourceValue:	values;
		runEnqueueMapForRangeAsOptionsBlockingForWaitDo1.
]

{ #category : 'tests' }
CommandQueueOpenCLRudesheimTest >> testReadFromCountElementTypeRoundTripsDouble0_0 [
	|
		target
		buffer
		result
	|

	target :=
		self
			trackForRelease:
			(
				self targetClass
					clCommandQueueFor:		self clDevices first
					of:						self clContext
			).

	buffer :=
		self
			trackForRelease:
			(
				self clContext
					newCLBufferWith:
					{
						1.25. 2.75. 3.125. 4.0625.
					}
					elementType:	TFBasicType double
			).

	result :=
		target
			readFrom:	buffer
			count:	4
			elementType:	TFBasicType double.

	self
		assertCollection:	result
		equals:
		{
			1.25. 2.75. 3.125. 4.0625.
		}.
]

{ #category : 'tests' }
CommandQueueOpenCLRudesheimTest >> testReadFromCountElementTypeRoundTripsFloat0_0 [
	|
		target
		buffer
		result
	|

	target :=
		self
			trackForRelease:
			(
				self targetClass
					clCommandQueueFor:		self clDevices first
					of:						self clContext
			).

	buffer :=
		self
			trackForRelease:
			(
				self clContext
					newCLBufferWith:
					{
						1.5. 2.5. 3.5. 4.5.
					}
					elementType:	TFBasicType float
			).

	result :=
		target
			readFrom:	buffer
			count:	4
			elementType:	TFBasicType float.

	self
		assertCollection:	result
		equals:
		{
			1.5. 2.5. 3.5. 4.5.
		}.
]

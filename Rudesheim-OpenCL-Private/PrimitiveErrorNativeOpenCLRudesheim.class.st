Class {
	#name : 'PrimitiveErrorNativeOpenCLRudesheim',
	#superclass : 'Error',
	#instVars : [
		'errorCode'
	],
	#classInstVars : [
		'mapOfCodeToName'
	],
	#category : 'Rudesheim-OpenCL-Private-Errors-Core',
	#package : 'Rudesheim-OpenCL-Private',
	#tag : 'Errors-Core'
}

{ #category : 'namespace' }
PrimitiveErrorNativeOpenCLRudesheim class >> Detailed [ ^ DetailedPrimitiveErrorNativeOpenCLRudesheim
]

{ #category : 'accessing' }
PrimitiveErrorNativeOpenCLRudesheim class >> defaultMapOfCodeToName [

	^
	{
		1 -> 'device_not_found'.
		2 -> 'device_not_available'.
		3 -> 'compiler_not_available'.
		4 -> 'mem_object_allocation_failure'.
		5 -> 'out_of_resources'.
		6 -> 'out_of_host_memory'.
		7 -> 'profiling_info_not_available'.
		8 -> 'mem_copy_overlap'.
		9 -> 'image_format_mismatch'.
		10 -> 'image_format_not_supported'.
		11 -> 'build_program_failure'.
		12 -> 'map_failure'.
		13 -> 'misaligned_sub_buffer_offset'.
		14 -> 'exec_status_error_for_events_in_wait_list'.
		15 -> 'compile_program_failure'.
		16 -> 'linker_not_available'.
		17 -> 'link_program_failure'.
		18 -> 'device_partition_failed'.
		19 -> 'kernel_arg_info_not_available'.
		30 -> 'invalid_value'.
		31 -> 'invalid_device_type'.
		32 -> 'invalid_platform'.
		33 -> 'invalid_device'.
		34 -> 'invalid_context'.
		35 -> 'invalid_queue_properties'.
		36 -> 'invalid_command_queue'.
		37 -> 'invalid_host_ptr'.
		38 -> 'invalid_mem_object'.
		39 -> 'invalid_image_format_descriptor'.
		40 -> 'invalid_image_size'.
		41 -> 'invalid_sampler'.
		42 -> 'invalid_binary'.
		43 -> 'invalid_build_options'.
		44 -> 'invalid_program'.
		45 -> 'invalid_program_executable'.
		46 -> 'invalid_kernel_name'.
		47 -> 'invalid_kernel_definition'.
		48 -> 'invalid_kernel'.
		49 -> 'invalid_arg_index'.
		50 -> 'invalid_arg_value'.
		51 -> 'invalid_arg_size'.
		52 -> 'invalid_kernel_args'.
		53 -> 'invalid_work_dimension'.
		54 -> 'invalid_work_group_size'.
		55 -> 'invalid_work_item_size'.
		56 -> 'invalid_global_offset'.
		57 -> 'invalid_event_wait_list'.
		58 -> 'invalid_event'.
		59 -> 'invalid_operation'.
		60 -> 'invalid_gl_object'.
		61 -> 'invalid_buffer_size'.
		62 -> 'invalid_mip_level'.
		63 -> 'invalid_global_work_size'.
		64 -> 'invalid_property'.
		65 -> 'invalid_image_descriptor'.
		66 -> 'invalid_compiler_options'.
		67 -> 'invalid_linker_options'.
		68 -> 'invalid_device_partition_count'.
	} asDictionary.
]

{ #category : 'accessing' }
PrimitiveErrorNativeOpenCLRudesheim class >> mapOfCodeToName [

	^ mapOfCodeToName
		ifNil:
		[
			mapOfCodeToName := self defaultMapOfCodeToName.
		].

]

{ #category : 'asserting' }
PrimitiveErrorNativeOpenCLRudesheim class >> shouldZero:	aBlock [
	|
		error
	|

	error := aBlock value.

	0 = error
		ifTrue:
		[
			^ 0.
		].

	^ self new
		setErrorCode: error;
		signal:
		(
			self mapOfCodeToName
				at:	-1 * error
				ifAbsent:
				[
					'Unknown error'
				]
		).
]

{ #category : 'exceptioninstantiator' }
PrimitiveErrorNativeOpenCLRudesheim class >> signal [

	^ self shouldNotImplement.
]

{ #category : 'exceptioninstantiator' }
PrimitiveErrorNativeOpenCLRudesheim class >> signal: message [

	^ self shouldNotImplement.
]

{ #category : 'exceptioninstantiator' }
PrimitiveErrorNativeOpenCLRudesheim class >> signal: message in: context [

	^ self shouldNotImplement.
]

{ #category : 'exceptioninstantiator' }
PrimitiveErrorNativeOpenCLRudesheim class >> signal: message withTag: aTag [

	^ self shouldNotImplement.
]

{ #category : 'exceptioninstantiator' }
PrimitiveErrorNativeOpenCLRudesheim class >> signalIn: context [

	^ self shouldNotImplement.
]

{ #category : 'accessing' }
PrimitiveErrorNativeOpenCLRudesheim >> defaultErrorCode [

	^ 0.

]

{ #category : 'accessing' }
PrimitiveErrorNativeOpenCLRudesheim >> errorCode [

	^ errorCode
		ifNil:
		[
			errorCode := self defaultErrorCode.
		].

]

{ #category : 'initialization' }
PrimitiveErrorNativeOpenCLRudesheim >> setErrorCode: anInteger [

	errorCode := anInteger.
]

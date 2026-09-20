Class {
	#name : 'BaselineOfRudesheimOpenCL',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfRudesheimOpenCL',
	#package : 'BaselineOfRudesheimOpenCL'
}

{ #category : 'baselines' }
BaselineOfRudesheimOpenCL >> baseline: spec [
	<baseline>

	spec
		for:	#common
		do:
		[
			spec
				baseline:	'RudesheimKernel'
				with:
				[
					spec
						repository:	'github://devid-rudesheim/Kernel-Rudesheim-Pharo:develop'.
				];
				project:	'RudesheimKernelTests'
				copyFrom:	'RudesheimKernel'
				with:
				[
					spec
						loads:	#( 'tests' ).
				];
				package:	'Rudesheim-OpenCL-Private'
				with:
				[
					spec
						requires:	#( 'RudesheimKernel' ).
				];
				package:	'Rudesheim-OpenCL'
				with:
				[
					spec
						requires:	#( 'Rudesheim-OpenCL-Private' ).
				];
				package:	'Rudesheim-OpenCL-Private-Tests'
				with:
				[
					spec
						requires:	#( 'Rudesheim-OpenCL' 'RudesheimKernelTests' ).
				];
				package:	'Rudesheim-OpenCL-Tests'
				with:
				[
					spec
						requires:	#( 'Rudesheim-OpenCL' 'RudesheimKernelTests' ).
				];
				group:	#core
				with:	#( 'Rudesheim-OpenCL-Private' 'Rudesheim-OpenCL' );
				group:	#tests
				with:	#( 'Rudesheim-OpenCL-Private-Tests' 'Rudesheim-OpenCL-Tests' );
				group:	#default
				with:	#( #core ).
		].
]

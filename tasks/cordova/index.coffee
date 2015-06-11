module.exports = ({gulp, $, config, globalConfig}) ->
	require('./'+task)({gulp, $, config, globalConfig}) for task in [
		'init-destroy'
		'clean'
		'build'
		'run'
		'deploy'
		'use'
	]

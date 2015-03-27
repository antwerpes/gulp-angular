module.exports = ({gulp, $, config, globalConfig}) ->
	console.log config
	require('./'+task)({gulp, $, config, globalConfig}) for task in [
		'build'
		'watch'
	]

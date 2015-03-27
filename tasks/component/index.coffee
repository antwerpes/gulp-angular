module.exports = ({gulp, $, config, globalConfig}) ->
	require('./'+task)({gulp, $, config: config?[task], globalConfig}) for task in [
		'build'
		'watch'
	]

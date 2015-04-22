module.exports = ({gulp, $, config, globalConfig}) ->
	require('./'+task)({gulp, $, config, globalConfig}) for task in [
		'e2e'
		'karma'
	]

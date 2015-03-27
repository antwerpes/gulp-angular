module.exports = ({gulp, $, config, globalConfig}) ->
	require('./'+task)({gulp, $, globalConfig}) for task in [
		'directive'
		'service'
		'provider'
		'factory'
		'filter'
		'controller'
	]

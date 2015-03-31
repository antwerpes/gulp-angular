module.exports = ({gulp, $, config, globalConfig}) ->
	require('./'+task)({gulp, $, config, globalConfig}) for task in [
		'project'
		'directive'
		'service'
		'provider'
		'factory'
		'filter'
		'controller'
	]

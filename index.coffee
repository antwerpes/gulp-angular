module.exports = (gulp, config, packageJson) ->
	require(task)(gulp, config, packageJson) for task in [
		'./tasks/core'
		'./tasks/component'
		'./tasks/cordova'
		'./tasks/webkit'
	]

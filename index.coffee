module.exports = (gulp, packageJson) ->
	require(task)(gulp, packageJson) for task in [
		'./tasks/core'
		'./tasks/component'
		'./tasks/cordova'
		'./tasks/webkit'
	]

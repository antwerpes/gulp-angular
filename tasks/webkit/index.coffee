$ =
	nodeWebkitBuilder: require 'node-webkit-builder'

module.exports = (gulp, packageJson) ->
	$.packageJson = packageJson
	require(task)(gulp, $) for task in [
		'./build'
	]

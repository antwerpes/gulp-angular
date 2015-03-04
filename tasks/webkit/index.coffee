$ =
	nodeWebkitBuilder: require 'node-webkit-builder'

module.exports = (gulp, config, packageJson) ->
	$.config = config
	$.packageJson = packageJson
	require(task)(gulp, $) for task in [
		'./build'
	]

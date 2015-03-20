$ =
	shell:  require 'gulp-shell'
	nodeWebkitBuilder: require 'node-webkit-builder'

module.exports = (gulp, packageJson) ->
	$.packageJson = packageJson
	$.runSequence = require('run-sequence').use(gulp)
	require(task)(gulp, $) for task in [
		'./build'
	]

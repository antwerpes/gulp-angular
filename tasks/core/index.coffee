module.exports = (gulp, packageJson, $) ->
	try $.sass = require 'gulp-sass'
	catch e
		console.warn 'sass not available'
		$.sass = $.util.noop
	$.handleStreamError = require '../../helper/handle-stream-error'
	$.packageJson = packageJson
	$.runSequence = require('run-sequence').use(gulp)
	require(task)(gulp, $) for task in [
		'./clean'
		'./transpile'
		'./inject'
		'./watch'
		'./serve'
		'./build'
		'./bower-assets'
	]

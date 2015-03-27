module.exports = ({gulp, $, config, globalConfig}) ->
	try $.sass = require 'gulp-sass'
	catch e
		console.warn 'sass not available'
		$.sass = $.util.noop

	require('./'+task)({gulp, $, config, globalConfig}) for task in [
		'clean'
		'transpile'
		'inject'
		'watch'
		'serve'
		'build'
		'bower-assets'
	]

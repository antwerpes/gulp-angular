$ =
	handleStreamError: require '../../helper/handle-stream-error'
	util:							 require 'gulp-util'
	gracefulChokidar:  require 'graceful-chokidar'
	filter:						 require 'gulp-filter'
	cssretarget:       require 'gulp-cssretarget'
	concat: 					 require 'gulp-concat'
	minifyHtml:        require 'gulp-minify-html'
	ngHtml2js:         require 'gulp-ng-html2js'
	rename:            require 'gulp-rename'
	size:              require 'gulp-size'
	changed:           require 'gulp-changed'

module.exports = (gulp, config, packageJson) ->
	$.config = config
	$.packageJson = packageJson
	$.runSequence = require('run-sequence').use(gulp)
	require(task)(gulp, $) for task in [
		'./build'
		'./watch'
	]

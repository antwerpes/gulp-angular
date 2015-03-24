module.exports = (gulp, packageJson) ->
	path = require 'path'
	$ = require('gulp-load-plugins')(
		pattern: [
			'gulp-*'
			'graceful-chokidar'
			'del'
			'xml2json'
			'node-webkit-builder'
			'wiredep'
			'browser-sync'
			'main-bower-files'
			'lazypipe'
			'uglify-save-license'
			'merge-stream'
		]
		config: path.join(__dirname, 'package.json')
		scope: ['dependencies']
		lazy: yes
	)

	$.path = path
	$.fs = require 'fs'
	$.runSequence = require('run-sequence').use(gulp)
	$.handleStreamError = require './helper/handle-stream-error'
	require(task)(gulp, packageJson, $) for task in [
		'./tasks/core'
		'./tasks/component'
		'./tasks/cordova'
		'./tasks/webkit'
		'./tasks/create'
	]

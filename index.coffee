module.exports = (gulp, config) ->
	path = require 'path'
	$ = require('gulp-load-plugins')(
		pattern: [
			'gulp-*'
			'graceful-chokidar'
			'del'
			'xml2json'
			'nw-builder'
			'wiredep'
			'browser-sync'
			'main-bower-files'
			'lazypipe'
			'uglify-save-license'
			'merge-stream'
			'deep-extend'
			'convict'
			'chalk'
		]
		config: path.join(__dirname, 'package.json')
		scope: ['dependencies']
		lazy: yes
	)

	$.path = path
	$.fs = require 'fs'
	$.runSequence = require('run-sequence').use(gulp)
	$.handleStreamError = require './helper/handle-stream-error'

	conf = $.convict require './config/gulp-angular.conf'

	conf.load(config)

	conf.validate()

	globalConfig = conf.get()

	unless globalConfig.angularModuleName
		return console.error $.chalk.bgRed.white 'Error: no angular module name given. this is necessary to allow automatic template conversion and ng-annotate to work'

	require('./tasks/' + task)({gulp, $, config: conf.get(task), globalConfig}) for task in [
		'web'
		'component'
		'cordova'
		'nwjs'
		'create'
		'test'
	]

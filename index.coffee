module.exports = (gulp, config) ->
	path = require 'path'
	$ = require('gulp-load-plugins')(
		pattern: [
			'gulp-*'
			'graceful-chokidar'
			'del'
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

	# require politor plugins
	$.politor = require('gulp-load-plugins')(
		pattern: [
			'politor-*'
		],
		config: path.join(path.dirname(module.parent.parent.filename), 'package.json')
		lazy: no
	)

	$.path = path
	$.fs = require 'fs'
	$.runSequence = require('run-sequence').use(gulp)
	$.handleStreamError = require './helper/handle-stream-error'

	globalConfig = config

	config.web ?= {
		sourcemaps: no
	}

	unless globalConfig.angularModuleName
		return console.error $.chalk.bgRed.white 'Error: no angular module name given. this is necessary to allow automatic template conversion and ng-annotate to work'

	require('./tasks/' + task)({gulp, $, config: config[task], globalConfig}) for task in [
		'web'
		'component'
		'test'
	]

	## init politor plugins

	for taskname, mod of $.politor
		mod({gulp, config: config[taskname.replace('politor','').toLowerCase()], globalConfig})


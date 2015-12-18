module.exports = (gulp, config) ->
	path = require 'path'
	lazy_require = (libs) ->
		e = {}
		for lib in libs
			do (lib) -> Object.defineProperty e,
				lib.replace(/\b-([a-z])/g, (all, char) -> char.toUpperCase()),
				get: -> require(lib)
		e

	$ = lazy_require [
		'gulp-angular-filesort'
		'gulp-autoprefixer'
		'gulp-changed'
		'gulp-coffee'
		'gulp-coffeelint'
		'gulp-concat'
		'gulp-cssretarget'
		'gulp-filter'
		'gulp-if'
		'gulp-ignore'
		'gulp-inject'
		'gulp-jade'
		'gulp-less'
		'gulp-minify-css'
		'gulp-minify-html'
		'gulp-ng-annotate'
		'gulp-ng-classify'
		'gulp-ng-html2js'
		'gulp-rename'
		'gulp-rev'
		'gulp-sourcemaps'
		'gulp-uglify'
		'gulp-useref'
		'gulp-util'
		'graceful-chokidar'
		'del'
		'wiredep'
		'browser-sync'
		'main-bower-files'
		'lazypipe'
		'uglify-save-license'
		'merge-stream'
	]

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
	]

	## init politor plugins

	for taskname, mod of $.politor
		mod({gulp, config: config[taskname.replace('politor','').toLowerCase()], globalConfig})


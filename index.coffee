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

	$.fs = require 'fs'
	$.path = path

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
	do () ->
		parentDir = path.join(path.dirname(module.parent.parent.filename))
		parentPjson = $.fs.readFileSync(path.join(parentDir, 'package.json'), 'utf-8')
		try
			parentPjson = JSON.parse(parentPjson)
		catch parsingError
			console.log 'failt to parse the parent package.json', parsingError
			return
		for plugin of parentPjson.devDependencies
			continue if plugin.indexOf('politor-') isnt 0
			try
				pluginf = require(path.join(parentDir, 'node_modules', plugin))
				pluginf({gulp, config: config[plugin.replace('politor','').toLowerCase()] or {}, globalConfig})
			catch initError
				console.log 'failed to load politor-plugin: ' + plugin, initError



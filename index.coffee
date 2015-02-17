# Batch-load plugins into one scope:
$ = require('gulp-load-plugins') pattern: [
	'gulp-*'
	'del'
	'wiredep'
	'browser-sync'
	'graceful-chokidar'
	'run-sequence'
	'main-bower-files'
	'uglify-save-license'
	'lazypipe'
]

# Augment plugin scope with builtins:
$.path = require 'path'
$.fs = require 'fs'

# Import the project's package.json into the plugin scope to
# acquire the package name which is required to equal the
# module name of the angular app:
$.packageJson = require '../../package.json' # TODO: find it automatically

$.handleStreamError = (err) ->
	# FIXME: something's wrong, doesn't stop on startup
	# when used with $.sequence (e.g. core:serve:dev) but works when
	# called in a task that is called directly (e.g. core:transpile:styles)
	console.error err.toString()
	$.util.beep()
	@emit 'end'

# TODO: use https://www.npmjs.com/package/fs-walk to walk recursively through tasks directory
tasks = [
	'./tasks/core/clean'
	'./tasks/core/transpile'
	'./tasks/core/inject'
	'./tasks/core/watch'
	'./tasks/core/serve'
	'./tasks/core/dist'
]

module.exports = (gulp) ->
	require(task)(gulp, $) for task in tasks

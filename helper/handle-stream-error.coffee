gutil = require 'gulp-util'

module.exports = () ->
	return handleStreamError = (err) ->
		# FIXME: something's wrong, doesn't stop on startup
		# when used with $.sequence (e.g. core:serve:dev) but works when
		# called in a task that is called directly (e.g. core:transpile:styles)
		console.error err.toString()
		gutil.beep()
		@emit 'end'

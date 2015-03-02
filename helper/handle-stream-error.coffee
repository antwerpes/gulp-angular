gutil = require 'gulp-util'

module.exports = (err) ->
		console.error err.toString()
		gutil.beep()
		@emit 'end'

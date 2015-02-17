module.exports = (gulp, $) ->
	# Deletes tmp and empties the dist directory leaving the directory itself
	# intact so that symlinks pointing to it (e.g. cordova www) don't break.
	gulp.task 'core:clean', (cb) -> $.del ['tmp', 'dist/*'], cb

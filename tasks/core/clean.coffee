module.exports = (gulp, $) ->
	# Deletes tmp and empties the dist directory leaving the directory itself
	# intact so that symlinks pointing to it (e.g. cordova www) don't break.
	gulp.task 'core:clean:dist', (cb) -> $.del ['dist/*'], cb
	gulp.task 'core:clean:tmp', (cb) -> $.del ['tmp'], cb
	gulp.task 'core:clean', ['core:clean:dist', 'core:clean:tmp']

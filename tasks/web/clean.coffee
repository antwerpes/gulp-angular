module.exports = ({gulp, $, config}) ->
	# Deletes tmp and empties the dist directory leaving the directory itself
	# intact so that symlinks pointing to it (e.g. cordova www) don't break.
	gulp.task 'web:clean:dist', (cb) -> $.del ['dist/*'], cb
	gulp.task 'web:clean:tmp', (cb) -> $.del ['tmp'], cb
	gulp.task 'web:clean', ['web:clean:dist', 'web:clean:tmp']

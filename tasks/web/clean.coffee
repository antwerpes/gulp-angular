module.exports = ({gulp, $, config}) ->
	# Deletes tmp and empties the dist directory leaving the directory itself
	# intact so that symlinks pointing to it (e.g. cordova www) don't break.
	gulp.task 'web:dist:clean', (cb) -> $.del ['dist/*'], cb
	gulp.task 'web:tmp:clean', (cb) -> $.del ['tmp'], cb
	gulp.task 'web:clean', ['web:dist:clean', 'web:tmp:clean']

# Requirements:
# - dev and dist directories need to have a .gitkeep file
# - need a generator that sets up the cordova project as a subdirectory
# - generator will replace the cordova-generated www directory with an initial symlink to dev

module.exports = ({gulp, $, config}) ->
	gulp.task 'cordova:use:dev', ->
		gulp.src('').pipe $.shell [
			'ln -sfn ../dev www'
		], cwd: config.path

	gulp.task 'cordova:use:dist', ->
		gulp.src('').pipe $.shell [
			'ln -sfn ../dist www'
		], cwd: config.path

	gulp.task 'cordova:uses', ->
		gulp.src('').pipe $.shell [
			"ls -l www | awk '{print $11}'"
		], cwd: config.path

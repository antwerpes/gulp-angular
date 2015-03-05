# TODO: let cordova:init task generate gulp-angular-config.js (?)

module.exports = (gulp, $) ->
	path = $.packageJson['gulp-angular']?.cordova?.build?.path

	# Generates Cordova iOS and Android platform projects
	# by simply executing `cordova platform add ios and
	# `cordova platform add android` shell commands.
	gulp.task 'cordova:init', ['cordova:destroy'], $.shell.task [
		'cordova platform add ios'
		'cordova platform add android'
		'echo'
		'echo'
		'echo IMPORTANT: in order for "gulp cordova:build:ios" to work properly, please open the generated Xcode project with Xcode and close it again. This is needed to generate some necessary files that xcodebuild command expects to be present.\n\n'
		'echo'
		'echo'
	], cwd: path

	# Deletes any cordova related output directories
	# like plugins, platforms and release
	# (that can be regenerated at any time).
	gulp.task 'cordova:destroy', (cb) ->
		return cb() unless path
		$.del [$.path.join(path, 'plugins'), $.path.join(path, 'platforms'), $.path.join(path, 'release')], cb

module.exports = ({gulp, $, config}) ->
	path = $.path.join process.cwd(), config.path

	# Generates Cordova iOS and Android platform projects
	# by simply executing `cordova platform add ios and
	# `cordova platform add android` shell commands.
	# Also adds plugins defined in config.cordova.plugins.

	installPlugins = []
	installPlugins.push('cordova plugin add ' + plugin) for plugin in config.plugins
	if installPlugins.length > 0 then console.log "DEPRICATED: Plugin installation via gulp-angular is depricated. Please use 'cordova plugin add --save' instead."

	gulp.task 'cordova:init', ['cordova:destroy'], $.shell.task([
		'rm www || true'
		'mkdir www'
		'cordova platform add ios'
		'cordova platform add android'
	].concat(installPlugins).concat([
		'rmdir www'
		'ln -sfn ../dev www'
		'echo'
		'echo'
		'echo IMPORTANT: in order for "gulp cordova:ios:build" to work properly, please open the generated Xcode project with Xcode and close it again. This is needed to generate some necessary files that xcodebuild command expects to be present.\n\n'
		'echo'
		'echo'
	]), cwd: path)

	# Deletes any cordova related output directories
	# like plugins, platforms and release
	# (that can be regenerated at any time).
	gulp.task 'cordova:destroy', () ->
		return cb() unless path
		$.del [
			$.path.join(path, 'www'),
			$.path.join(path, 'plugins'),
			$.path.join(path, 'platforms'),
			$.path.join(path, 'release')
		]

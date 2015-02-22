module.exports = (gulp, $) ->

	# Runs the iOS platform project on the currently plugged-in device.
	# Requires 'ios-deploy' node module to be installed globally.
	gulp.task 'cordova:run:ios', ->
		gulp.src('').pipe $.shell [
			'cordova prepare'
			'cordova run ios'
		]

	# Runs the Android platform project on the currently plugged-in device.
	gulp.task 'cordova:run:android', ->
		gulp.src('').pipe $.shell [
			'cordova prepare'
			'cordova run android'
		]
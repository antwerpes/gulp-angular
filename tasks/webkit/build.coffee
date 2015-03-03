module.exports = (gulp, $) ->
	config = $.packageJson['gulp-angular-config']?['node-webkit-builder'] or {}
	# see config options in https://github.com/mllrsohn/node-webkit-builder
	config.appName = $.packageJson.name
	config.apVersion = $.packageJson.version
	config.buildDir ?= 'node-webkit'
	config.cacheDir ?= '.node-webkit-cache'
	config.platforms ?= ['win','osx']
	config.files = 'dist/**/**'

	gulp.task 'webkit:build', ['core:build'], ->
		gulp.start 'webkit:build:dirty'

	gulp.task 'webkit:build:dirty', ->
		new $.nodeWebkitBuilder config
			.on 'log', console.log
			.build().then ->
				console.log 'node webkit Build done!'
			.catch (error) ->
				console.error error
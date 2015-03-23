module.exports = (gulp, $) ->
	config = $.packageJson['gulp-angular']?['webkit'] or {}
	# see config options in https://github.com/mllrsohn/node-webkit-builder
	config.appName ?= $.packageJson.name
	config.appVersion = $.packageJson.version
	config.buildDir ?= 'node-webkit'
	config.cacheDir ?= '.node-webkit-cache'
	config.platforms ?= ['win','osx']
	config.files = 'dist/**/**'

	gulp.task 'webkit:build:dirty', ['core:build:dirty'], (cb) ->
		$.runSequence 'webkit:build:copy-dist', cb
		
	gulp.task 'webkit:build', ['core:build'], (cb) ->
		$.runSequence 'webkit:build:copy-dist', cb

	gulp.task 'webkit:build:npm-install', () ->
		gulp.src('').pipe $.shell [
			'npm install'
		], cwd: 'dist'
	
	gulp.task 'webkit:build:copy-dist', ['webkit:build:npm-install'], () ->
		new $.nodeWebkitBuilder config
			.on 'log', console.log
			.build().then ->
				console.log 'webkit done'
			.catch (error) ->
				console.error error
module.exports = ({gulp, $, config}) ->
	config.currentArchitecture = switch process.platform
    when 'darwin'
      if process.arch == 'x64' then 'osx64' else 'osx32'
    when 'win32'
     	 if process.arch == 'x64' or process.env.hasOwnProperty('PROCESSOR_ARCHITEW6432') then 'win64' else 'win32'
    when 'linux'
       if process.arch == 'x64' then 'linux64' else 'linux32'

	devConfig = $.deepExtend({}, config)
	devConfig.appName = devConfig.appName + '_dev'
	devConfig.files = 'tmp/package.json'

	gulp.task 'nwjs:build', ['web:build'], (cb) ->
		$.runSequence 'nwjs:build:copy-dist', cb

	gulp.task 'nwjs:build:npm-install', () ->
		gulp.src('').pipe $.shell [
			'npm install'
		], cwd: 'dist'

	gulp.task 'nwjs:build:copy-dist', ['nwjs:build:npm-install'], (cb) ->
		new $.nodeWebkitBuilder config
			.on 'log', console.log
			.build().then ->
				console.log 'webkit done'
			.catch (error) ->
				console.error error

	gulp.task 'nwjs:build:dev:modifyPackageJson', () ->
		devPackage =
			"main": "http://localhost:3000"
			"node-remote": "<local>"

		devPackage = $.deepExtend devPackage, config.dev?.packageOverrides
		gulp.src 'src/package.json', base: 'src'
			.pipe $.jsonEditor devPackage
			.pipe gulp.dest('tmp')

	gulp.task 'nwjs:build:createDev', ->
		new $.nodeWebkitBuilder devConfig
				.on 'log', console.log
				.build().then ->
					console.log 'webkit done'
				.catch (error) ->
					console.error error


	gulp.task 'nwjs:build:npm-install:dev', () ->
		gulp.src('').pipe $.shell [
			'npm install'
		], cwd: $.path.join devConfig.buildDir, devConfig.appName, devConfig.currentArchitecture, devConfig.appName + '.app', 'Contents', 'Resources', 'app.nw'

	gulp.task 'nwjs:build:dev', ['nwjs:build:dev:modifyPackageJson'], (cb) ->
		$.del $.path.join(devConfig.buildDir, devConfig.appName, devConfig.currentArchitecture, devConfig.appName + '.app')
		$.runSequence 'nwjs:build:createDev', 'nwjs:build:npm-install:dev', cb


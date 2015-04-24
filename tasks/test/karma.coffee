module.exports = ({gulp, $, config}) ->

	gulp.task 'test:build', (cb) ->
		$.runSequence 'web:dev:build', 'web:dist:partials', cb

	gulp.task 'test:unit', ['test:build'], ->
		bowerDeps = $.wiredep
			directory: 'bower_components'
			dependencies: true
			devDependencies: true

		bowerStream = gulp.src bowerDeps.js, nodir: yes

		appFiles = gulp.src([
			'dev/!(bower_components)/**/*.js'
			'!dev/**/*.e2e.js'
		]).pipe $.angularFilesort()

		$.mergeStream(bowerStream, appFiles)
			.pipe $.karma
				configFile: 'karma.conf.js'
				action: 'run'
				basePath: 'dev'
			.on 'error', (err) ->
				# Make sure failed tests cause gulp to exit non-zero
				console.log $.karma
				throw err
				return

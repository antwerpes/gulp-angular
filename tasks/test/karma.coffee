module.exports = ({gulp, $, config}) ->

	gulp.task 'test:build', (cb) ->
		$.runSequence 'web:build:dev', 'web:build:partials', cb

	gulp.task 'test:karma', ['test:build'], ->
		bowerDeps = $.wiredep
			directory: 'bower_components'
			dependencies: true
			devDependencies: true

		bowerStream = gulp.src bowerDeps.js, nodir: yes

		appFiles = gulp.src([
			'tmp/!(bower_components)/**/*.js'
			'!tmp/**/*.e2e.js'
		]).pipe $.angularFilesort()

		$.mergeStream(bowerStream, appFiles)
			.pipe $.karma
				configFile: 'karma.conf.js'
				action: 'run'
				basePath: 'tmp'
			.on 'error', (err) ->
				# Make sure failed tests cause gulp to exit non-zero
				console.log $.karma
				throw err
				return


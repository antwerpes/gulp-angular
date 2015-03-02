module.exports = (gulp, $) ->
	# Transpiles less and sass files found in src into css files copied to tmp.
	# Automatically adds vendor prefixes after transpilation.
	gulp.task 'core:transpile:styles', ->
		gulp.src ['src/**/*.{less,scss}', '!src/bower_components/**']
			.pipe $.changed 'tmp', extension: '.css' # keep traffic low (important for watch task)
			.pipe($.if '*.less', $.less())
				.on 'error', $.handleStreamError
			.pipe $.if '*.scss', $.sass
				onError: (err) ->
					# FIXME: abort on startup, continue when watching
					# TODO: investigate when task is called within $.sequence
					console.error err
					$.util.beep()
			.pipe $.autoprefixer()
			.pipe gulp.dest 'tmp'
			.pipe $.browserSync.reload stream: yes
			.pipe $.size()

	# Transpiles coffee files found in src into js files copied to tmp.
	# Lints coffeescript and converts coffeescript classes to angular
	# syntax (ng-classify) before transpilation. Sourcemaps are not supported yet.
	gulp.task 'core:transpile:scripts', ->
		gulp.src ['src/**/*.coffee', '!src/bower_components/**']
			.pipe $.changed 'tmp', extension: '.js' # keep traffic low (important for watch task)
			.pipe $.ngClassify appName: $.packageJson.name
			.pipe $.coffeelint()
			.pipe $.coffeelint.reporter()
			.pipe $.coffee sourceMap: false
				.on 'error', $.handleStreamError
			.pipe gulp.dest 'tmp'
			.pipe $.browserSync.reload stream: yes
			.pipe $.size()

	# Transpiles jade files found in src into html files copied to tmp.
	gulp.task 'core:transpile:templates', ->
		gulp.src ['src/**/*.jade', '!src/bower_components/**']
			.pipe $.changed 'tmp', extension: '.html' # keep traffic low (important for watch task)
			.pipe $.jade()
			.on 'error', $.handleStreamError
			.pipe gulp.dest 'tmp'
			.pipe $.browserSync.reload stream: yes
			.pipe $.size()

	# Transpiles styles and scripts from src to tmp.
	gulp.task 'core:transpile', ['core:transpile:styles', 'core:transpile:scripts', 'core:transpile:templates']
	

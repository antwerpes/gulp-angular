module.exports = ({gulp, $, config, globalConfig}) ->
	# Transpiles less and sass files found in src into css files copied to tmp.
	# Automatically adds vendor prefixes after transpilation.
	gulp.task 'web:transpile:styles', ->
		gulp.src ['src/**/*.{less,scss}']
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
	gulp.task 'web:transpile:scripts', ->
		gulp.src ['src/**/*.coffee']
			.pipe $.changed 'tmp', extension: '.js' # keep traffic low (important for watch task)
			.pipe $.ngClassify appName: globalConfig.angularModuleName
			.on 'error', $.handleStreamError
			.pipe $.coffeelint()
			.pipe $.coffeelint.reporter()
			.pipe $.coffee sourceMap: false
			.on 'error', $.handleStreamError
			.pipe gulp.dest 'tmp'
			.pipe $.browserSync.reload stream: yes
			.pipe $.size()

	# Transpiles jade files found in src into html files copied to tmp.
	gulp.task 'web:transpile:templates', ->
		gulp.src ['src/**/*.jade']
			.pipe $.changed 'tmp', extension: '.html' # keep traffic low (important for watch task)
			.pipe $.jade()
			.on 'error', $.handleStreamError
			.pipe gulp.dest 'tmp'
			.pipe $.browserSync.reload stream: yes
			.pipe $.size()

	# Transpiles styles and scripts from src to tmp.
	gulp.task 'web:transpile', ['web:transpile:styles', 'web:transpile:scripts', 'web:transpile:templates']

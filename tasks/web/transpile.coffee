module.exports = ({gulp, $, config, globalConfig}) ->
	# Transpiles less and sass files found in src into css files copied to dev.
	# Automatically adds vendor prefixes after transpilation.
	gulp.task 'web:dev:transpile:styles', ->
		gulp.src ['src/**/*.{less,scss,sass}']
			.pipe $.gulpChanged 'dev', extension: '.css' # keep traffic low (important for watch task)
			.pipe($.gulpIf '*.less', $.gulpLess())
				.on 'error', $.handleStreamError
			.pipe $.gulpIf /(\.scss|\.sass)$/, $.sass
				indentedSyntax: yes # enable sass syntax
				onError: (err) ->
					# FIXME: abort on startup, continue when watching
					# TODO: investigate when task is called within $.sequence
					console.error err
					$.gulpUtil.beep()
			.pipe $.gulpAutoprefixer()
			.pipe gulp.dest 'dev'
			.pipe $.browserSync.reload stream: yes

	# Transpiles coffee files found in src into js files copied to dev.
	# Lints coffeescript and converts coffeescript classes to angular
	# syntax (ng-classify) before transpilation. Sourcemaps are not supported yet.
	gulp.task 'web:dev:transpile:scripts', ->
		gulp.src ['src/**/*.coffee']
			.pipe $.gulpChanged 'dev', extension: '.js' # keep traffic low (important for watch task)
			.pipe $.gulpNgClassify appName: globalConfig.angularModuleName
			.on 'error', $.handleStreamError
			.pipe $.gulpCoffeelint()
			.pipe $.gulpCoffeelint.reporter()
			.pipe $.gulpCoffee sourceMap: false
			.on 'error', $.handleStreamError
			.pipe gulp.dest 'dev'
			.pipe $.browserSync.reload stream: yes

	# Transpiles jade files found in src into html files copied to dev.
	gulp.task 'web:dev:transpile:templates', ->
		gulp.src ['src/**/*.jade']
			.pipe $.gulpChanged 'dev', extension: '.html' # keep traffic low (important for watch task)
			.pipe $.gulpJade()
			.on 'error', $.handleStreamError
			.pipe gulp.dest 'dev'
			.pipe $.browserSync.reload stream: yes

	# Transpiles styles and scripts from src to dev.
	gulp.task 'web:dev:transpile', ['web:dev:transpile:styles', 'web:dev:transpile:scripts', 'web:dev:transpile:templates']

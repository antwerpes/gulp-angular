module.exports = ({gulp, $, config, globalConfig}) ->
	gulp.task 'component:assets', ->
		gulp.src ['src/**/*.*', '!**/*.{js,coffee,less,scss,css,html,jade}']
			.pipe $.changed 'dist'
			.pipe gulp.dest 'dist'

	# Minifies and packages html templates/partials found in src
	# into pre-cached angular template modules in dist.
	gulp.task 'component:partials', ['web:dev:transpile:templates'], ->
		gulp.src ['src/**/*.html', 'dev/**/*.html']
			.pipe $.minifyHtml
				empty: yes
				spare: yes
				quotes: yes
			.pipe $.ngHtml2js
				moduleName: globalConfig.angularModuleName
				declareModule: no
			.pipe $.rename suffix: '.partial'
			.pipe gulp.dest 'dev'
			.pipe $.size()

	gulp.task 'component:build-dirty', ['web:dev:transpile', 'component:assets', 'component:partials'], (cb) ->
		gulp.src ['{src,dev}/**/*.{js,css}', '!{src,dev}/**/*.{test,e2e}.js']
			.pipe cssFilter = $.filter('**/*.css', restore: yes)
			.pipe $.cssretarget
				root: 'dev'
				silent: true
			.pipe $.concat('main.css')
			.pipe gulp.dest 'dist'
			.pipe cssFilter.restore
			.pipe jsFilter = $.filter '**/*.js'
			.pipe $.angularFilesort()
			.pipe $.concat 'main.js'
			.pipe gulp.dest 'dist'

	gulp.task 'component:build', ['web:clean'], (cb) ->
		$.runSequence 'component:build-dirty', cb

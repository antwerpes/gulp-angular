module.exports = ({gulp, $, config}) ->
	gulp.task 'component:assets', ->
		gulp.src ['src/**/*.*', '!**/*.{js,coffee,less,scss,css,html,jade}']
			.pipe $.changed 'dist'
			.pipe gulp.dest 'dist'

	# Minifies and packages html templates/partials found in src
	# into pre-cached angular template modules in dist.
	gulp.task 'component:partials', ['web:transpile:templates'], ->
		gulp.src ['src/**/*.html', 'tmp/**/*.html']
			.pipe $.minifyHtml
				empty: yes
				spare: yes
				quotes: yes
			.pipe $.ngHtml2js moduleName: globalConfig.angularModuleName
			.pipe $.rename suffix: '.partial'
			.pipe gulp.dest 'tmp'
			.pipe $.size()

	gulp.task 'component:build-dirty', ['web:transpile', 'component:assets', 'component:partials'], (cb) ->
		gulp.src '{src,tmp}/**/*.{js,css}'
			.pipe cssFilter = $.filter '**/*.css'
			.pipe $.cssretarget(root: 'tmp')
			.pipe $.concat('main.css')
			.pipe gulp.dest 'dist'
			.pipe cssFilter.restore()
			.pipe jsFilter = $.filter '**/*.js'
			.pipe $.concat 'main.js'
			.pipe gulp.dest 'dist'

	gulp.task 'component:build', ['web:clean'], (cb) ->
		gulp.start('component:build-dirty')

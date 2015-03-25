module.exports = (gulp, $) ->
	# Watches bower.json and triggers inject when its content changes.
	# Watches less, sass and coffeescript files in src (not bower components)
	# and triggers retranspilation when their content changes. New files are
	# being transpiled and injected into tmp/index.html.
	# Counterparts in tmp of files being deleted from src are also being deleted
	# with inject being triggered afterwards.
	gulp.task 'core:watch', ['core:build:dev'], ->
		$.gracefulChokidar.watch 'bower.json',
				ignoreInitial: yes
				persistent: yes
			.on 'change', -> $.runSequence 'core:inject', 'core:build:assets:dev', () -> $.browserSync.reload()
		$.gracefulChokidar.watch 'src',
				ignored: /^.*\.(?!less$|scss$|coffee$|jade$)[^.]+$/
				ignoreInitial: yes
				persistent: yes
			.on 'add', (path) -> gulp.start 'core:inject'
			.on 'error', $.handleStreamError
			.on 'unlink', (path) ->
				tmpFile = path.replace /^src/, 'tmp'
					.replace /\.less$/, 'css'
					.replace /\.scss$/, 'css'
					.replace /\.coffee$/, 'js'
					.replace /\.jade$/, 'html'
				$.del tmpFile
				gulp.start 'core:inject'
			.on 'change', (path) ->
				gulp.start 'core:transpile:' + switch $.path.extname path
					when '.less', '.scss'	then 'styles'
					when '.coffee'			then 'scripts'
					when '.jade'			then 'templates'

		$.gracefulChokidar.watch 'src',
				ignored: /^.*\.(?!css$|html$|js$|png$|jpg$|gif$|svg$|ico$)[^.]+$/
				ignoreInitial: yes
				persistent: yes
			.on 'add', (path) -> gulp.start 'core:inject'
			.on 'error', $.handleStreamError
			.on 'unlink', (path) -> gulp.start 'core:inject'
			.on 'change', (path) ->
				switch $.path.extname path
					when '.html', '.js'	then $.browserSync.reload()
					else $.browserSync.reload path
		# chokidar doenst accept an array as first parameter, so we need to start the watcher on nothing and use the add function.
		$.gracefulChokidar.watch '!**/*',
				ignoreInitial: yes
				persistent: yes
			.add $.mainBowerFiles()
			.on 'change', (path)->
				switch $.path.extname path
					when '.js', '.css' then gulp.start('core:inject')


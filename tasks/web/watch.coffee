module.exports = ({gulp, $, config, globalConfig}) ->
	# Watches bower.json and triggers inject when its content changes.
	# Watches less, sass and coffeescript files in src (not bower components)
	# and triggers retranspilation when their content changes. New files are
	# being transpiled and injected into dev/index.html.
	# Counterparts in dev of files being deleted from src are also being deleted
	# with inject being triggered afterwards.
	gulp.task 'web:dev:watch', ['web:dev:build'], ->
		$.gracefulChokidar.watch 'bower.json',
				ignoreInitial: yes
				persistent: yes
			.on 'change', -> $.runSequence 'web:dev:inject', 'web:dev:assets', -> $.browserSync.reload()

		$.gracefulChokidar.watch 'src',
				ignored: /^.*\.(?!less$|scss$|coffee$|jade$)[^.]+$/
				ignoreInitial: yes
				persistent: yes
			.on 'add', (path) -> $.runSequence 'web:dev:inject'
			.on 'error', $.handleStreamError
			.on 'unlink', (path) ->
				devFile = path.replace /^src/, 'dev'
					.replace /\.less$/, '.css'
					.replace /\.scss$/, '.css'
					.replace /\.coffee$/, '.js'
					.replace /\.jade$/, '.html'
				$.del devFile
				$.runSequence 'web:dev:inject', 'web:dev:assets', -> $.browserSync.reload()
			.on 'change', (path) ->
				gulp.start 'web:dev:transpile:' + switch $.path.extname path
					when '.less', '.scss'	then 'styles'
					when '.coffee'			then 'scripts'
					when '.jade'			then 'templates'
				if $.path.exname in ['.html', '.css', '.js']
					$.runSequence 'web:build:copy-sources'

		$.gracefulChokidar.watch 'src',
				ignored: /^.*\.(?!css$|html$|js$|png$|jpg$|gif$|svg$|ico$)[^.]+$/
				ignoreInitial: yes
				persistent: yes
			.on 'add', (path) -> gulp.start 'web:dev:inject'
			.on 'error', $.handleStreamError
			.on 'unlink', (path) -> gulp.start 'web:dev:inject'
			.on 'change', (path) ->
				switch $.path.extname path
					when '.html', '.js'	then $.runSequence 'web:build:copy-sources', -> $.browserSync.reload(path)
					when '.css'	then $.runSequence 'web:build:copy-sources', -> $.browserSync.reload(path)
					else $.browserSync.reload path
		# chokidar doenst accept an array as first parameter, so we need to start the watcher on nothing and use the add function.
		$.gracefulChokidar.watch '!**/*',
				ignoreInitial: yes
				persistent: yes
			.add $.mainBowerFiles()
			.on 'change', (path)->
				switch $.path.extname path
					when '.js', '.css' then $.runSequence 'web:dev:inject', 'web:dev:assets', -> $.browserSync.reload()



module.exports = (gulp, $) ->
	# Watches bower.json and triggers inject when its content changes.
	# Watches less, sass and coffeescript files in src (not bower components)
	# and triggers retranspilation when their content changes. New files are
	# being transpiled and injected into tmp/index.html.
	# Counterparts in tmp of files being deleted from src are also being deleted
	# with inject being triggered afterwards.
	gulp.task 'core:watch', ['core:inject'], ->
		$.gracefulChokidar.watch 'bower.json',
				ignoreInitial: yes
				persistent: yes
			.on 'change', -> gulp.start 'core:inject'
		$.gracefulChokidar.watch 'src',
				ignored: /bower_components|^.*\.(?!less$|scss$|coffee$)[^.]+$/
				ignoreInitial: yes
				persistent: yes
			.on 'add', (path) -> gulp.start 'core:inject'
			.on 'error', (error) -> console.error('Error happened', error)
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

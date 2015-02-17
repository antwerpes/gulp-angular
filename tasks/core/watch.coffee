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
			.on 'unlink', (path) ->
				ext = $.path.extname path
				tmpFile = path.replace /^src/, 'tmp'
				tmpFile = tmpFile.replace /less$/, 'css' if ext == '.less'
				tmpFile = tmpFile.replace /scss$/, 'css' if ext == '.scss'
				tmpFile = tmpFile.replace /coffee$/, 'js' if ext == '.coffee'
				$.del tmpFile
				gulp.start 'core:inject'
			.on 'change', (path) ->
				ext = $.path.extname path
				gulp.start 'core:transpile:styles' if ext == '.less' or ext == '.scss'
				gulp.start 'core:transpile:scripts' if ext == '.coffee'

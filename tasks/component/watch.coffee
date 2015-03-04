module.exports = (gulp, $) ->
	# this might be used for bower_component development inside of another project
	# the parent project will watch the main-files from the bower_component,
	# so on change the watcher should build the dist-files, which are referenced in the bower.json
	# use carefully! this is meant for small bower_components, not huge projects
	gulp.task 'component:watch', ['component:build-dirty'], ->
		$.util.log $.util.colors.yellow('Warning: core:watch:dist is meant for small bower_components. don\'t use it on big projects')
		$.gracefulChokidar.watch 'src',
				ignored: /bower_components|^.*\.(?!less$|scss$|coffee$|jade$)[^.]+$/
				ignoreInitial: yes
				persistent: yes
			.on 'add', (path) -> gulp.start 'component:build-dirty'
			.on 'change', (path) ->
				gulp.start 'component:build-dirty'
			.on 'error', (error) -> console.error('Error happened', error)



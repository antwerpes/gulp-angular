module.exports = ({gulp, $, config, globalConfig}) ->
	generateAppCacheManifest = (dir) ->
		if globalConfig.generateApplicationCacheManifest == yes
			gulp.src(dir + '/**')
				.pipe $.manifest
					hash: yes
					timestamp: no
					preferOnline: yes
					filename: globalConfig.angularModuleName + '.appcache'
				.pipe gulp.dest dir
		else return $.util.noop()

	gulp.task 'web:dev:generate-appcache-manifest', -> generateAppCacheManifest 'dev'
	gulp.task 'web:dist:generate-appcache-manifest', -> generateAppCacheManifest 'dist'

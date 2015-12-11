module.exports = ({gulp, $, config, globalConfig}) ->
	generateAppCacheManifest = (dir) ->
		gulp.src [dir + '/**', '!' + globalConfig.offlineExludePattern]
			.pipe $.manifest
				hash: yes
				timestamp: no
				preferOnline: yes
				filename: globalConfig.angularModuleName + '.appcache'
			.pipe gulp.dest dir

	generateOfflineServiceWorkerFromAppCacheManifest = (dir) ->
		gulp.src(dir + '/' + globalConfig.angularModuleName + '.appcache')
			.pipe $.offlineServiceWorkerFromAppCacheManifest dir: dir
			.pipe gulp.dest dir

	gulp.task 'web:dev:offline:app-cache-manifest', -> generateAppCacheManifest 'dev'
	gulp.task 'web:dist:offline:app-cache-manifest', -> generateAppCacheManifest 'dist'

	gulp.task 'web:dev:offline:service-worker', -> generateOfflineServiceWorkerFromAppCacheManifest 'dev'
	gulp.task 'web:dist:offline:service-worker', -> generateOfflineServiceWorkerFromAppCacheManifest 'dist'

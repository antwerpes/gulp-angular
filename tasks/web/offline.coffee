module.exports = ({gulp, $, config, globalConfig}) ->
	generateAppCacheManifest = (dir) ->
		gulp.src(dir + '/**')
			.pipe $.manifest
				hash: yes
				timestamp: no
				preferOnline: yes
				filename: globalConfig.angularModuleName + '.appcache'
			.pipe gulp.dest dir

	generateServiceWorkerFromAppCacheManifest = (dir) ->
		gulp.src(dir + '/' + globalConfig.angularModuleName + '.appcache')
			.pipe $.generateServiceWorkerFromAppcacheManifest dir: dir
			.pipe gulp.dest dir

	gulp.task 'web:dev:generate-offline-appcache-manifest', -> generateAppCacheManifest 'dev'
	gulp.task 'web:dist:generate-offline-appcache-manifest', -> generateAppCacheManifest 'dist'

	gulp.task 'web:dev:generate-offline-service-worker-from-appcache-manifest', -> generateServiceWorkerFromAppCacheManifest 'dev'
	gulp.task 'web:dist:generate-offline-service-worker-from-appcache-manifest', -> generateServiceWorkerFromAppCacheManifest 'dist'

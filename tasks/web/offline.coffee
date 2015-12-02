module.exports = ({gulp, $, config, globalConfig}) ->

	# TODO: make this a gulp plugin/node module
	_generateServiceWorkerFromAppCacheManifest = (options) ->
		swjsTemplate = "/*https://github.com/react-europe/www/blob/cfp/app/sw.js*/var CACHE_VERSION={{HASH}};var CURRENT_CACHES={prefetch:'prefetch-cache-v'+CACHE_VERSION};self.addEventListener('install',function(event){var urlsToPrefetch={{URLS}};console.log('Handling install event. Resources to pre-fetch:',urlsToPrefetch);event.waitUntil(caches.open(CURRENT_CACHES['prefetch']).then(function(cache){return cache.addAll(urlsToPrefetch.map(function(urlToPrefetch){return new Request(urlToPrefetch,{mode:'no-cors'});})).then(function(){console.log('All resources have been fetched and cached.');});}).catch(function(error){console.error('Pre-fetching failed:',error);}));});self.addEventListener('activate',function(event){var expectedCacheNames=Object.keys(CURRENT_CACHES).map(function(key){return CURRENT_CACHES[key];});event.waitUntil(caches.keys().then(function(cacheNames){return Promise.all(cacheNames.map(function(cacheName){if(expectedCacheNames.indexOf(cacheName)==-1){console.log('Deleting out of date cache:',cacheName);return caches.delete(cacheName);}}));}));});self.addEventListener('fetch',function(event){console.log('Handling fetch event for',event.request.url);event.respondWith(caches.match(event.request).then(function(response){if(response){console.log('Found response in cache:',response);return response;}console.log('No response found in cache. About to fetch from network...');return fetch(event.request).then(function(response){console.log('Response from network is:',response);return response;}).catch(function(error){console.error('Fetching failed:',error);throw error;});}));});"
		options = options or {}
		filename = options.filename or 'sw.js'
		cwd = process.cwd()
		appCacheFile = null
		appCacheFileContent = null
		writeServiceWorker = (file, encoding, cb) ->
			appCacheFile = file
			appCacheFileContent = String file.contents
			cb()
		endStream = ->
			_this = this
			cacheFiles = $.parseAppcacheManifest(appCacheFileContent).cache
			swjsTemplate = swjsTemplate.replace '{{HASH}}', "'" + appCacheFileContent.match('# hash: (.*)$')[1] + "'"
			swjsTemplate = swjsTemplate.replace '{{URLS}}', JSON.stringify cacheFiles
			serviceWorkerFile = new $.util.File
				cwd: cwd
				base: cwd
				path: $.path.join cwd, filename
				contents: new Buffer swjsTemplate
			_this.emit 'data', appCacheFile
			_this.emit 'data', serviceWorkerFile
			_this.emit 'end'
		$.through2.obj(writeServiceWorker, endStream);

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
			.pipe _generateServiceWorkerFromAppCacheManifest dir: dir
			.pipe gulp.dest dir

	gulp.task 'web:dev:generate-offline-appcache-manifest', -> generateAppCacheManifest 'dev'
	gulp.task 'web:dist:generate-offline-appcache-manifest', -> generateAppCacheManifest 'dist'

	gulp.task 'web:dev:generate-offline-service-worker-from-appcache-manifest', -> generateServiceWorkerFromAppCacheManifest 'dev'
	gulp.task 'web:dist:generate-offline-service-worker-from-appcache-manifest', -> generateServiceWorkerFromAppCacheManifest 'dist'

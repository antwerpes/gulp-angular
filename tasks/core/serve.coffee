module.exports = (gulp, $) ->
	# Starts a local web server serving the development version of the web app.
	# Serves files from both the tmp and the src directories. Files in tmp
	# have precedence over those found in src, which is especially important
	# in order to ensure that the injected version of index.html gets served.
	gulp.task 'core:serve:browser-sync:dev', (cb) ->
		$.browserSync
			# files: [ # files being watched
			# 	'{tmp,src}/**/*.{html,css,js,png,jpg,gif,svg,ico}']
			# this is triggered manually to avoid having too many watches
			server:
				baseDir: ['tmp'] # order is important here! files in tmp have precedence
			startPath: '/index.html'
			browser: 'default'
			open: no
			ui: no
			ghostMode: no # disable syncing across browser instances
			online: no
			notify: yes
		, (err) -> if err? then $.handleStreamError(err) else cb()

	# Starts a local web server serving the production-/distribution-ready
	# version of the web app from the dist directory.
	gulp.task 'core:serve:browser-sync:dist', (cb) ->
		$.browserSync
			server:
				baseDir: 'dist'
			startPath: '/index.html'
			browser: 'default'
			open: no
			ghostMode: no # disable syncing across browser instances
			notify: yes
		, (err) -> if err then $.handleStreamError(err) else cb()

	# Builds and serves a clean development version of the web app while watching for source file changes.
	gulp.task 'core:serve:dev', (cb) -> $.runSequence 'core:watch', 'core:serve:browser-sync:dev', cb
	# Starts a local web server serving the production-/distribution-ready version of the web app.
	gulp.task 'core:serve:dist', (cb) -> $.runSequence 'core:build', 'core:serve:browser-sync:dist', cb

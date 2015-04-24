module.exports = ({gulp, $, config, globalConfig}) ->
	# Starts a local web server serving the development version of the web app.
	# Serves files from both the dev and the src directories. Files in dev
	# have precedence over those found in src, which is especially important
	# in order to ensure that the injected version of index.html gets served.
	gulp.task 'web:dev:browser-sync', (cb) ->
		$.browserSync
			# files: [ # files being watched
			# 	'{dev,src}/**/*.{html,css,js,png,jpg,gif,svg,ico}']
			# this is triggered manually to avoid having too many watches
			server:
				baseDir: 'dev'
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
	gulp.task 'web:dist:browser-sync', (cb) ->
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
	gulp.task 'web:dev:serve', (cb) -> $.runSequence 'web:dev:watch', 'web:dev:browser-sync', cb
	# Starts a local web server serving the production-/distribution-ready version of the web app.
	gulp.task 'web:dist:serve', (cb) -> $.runSequence 'web:build', 'web:dist:browser-sync', cb

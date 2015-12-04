# # TODO: read cordova project name from config.xml instead of gulp-angular-config.js

module.exports = ({gulp, $, config}) ->
	configXmlPath = $.path.join process.cwd(), config.path, 'config.xml'
	# if $.fs.existsSync(configXmlPath)
	# 	configXML = $.fs.readFileSync(configXmlPath,'ascii')
	# 	appName = '"' + $.xml2json.toJson(configXML, object: yes).widget.name + '"'

	gulp.task 'cordova:browser-sync', (cb) ->
		$.browserSync
			# files: [ # files being watched
			# 	'{dev,src}/**/*.{html,css,js,png,jpg,gif,svg,ico}']
			# this is triggered manually to avoid having too many watches
			server:
				baseDir: ['dev', $.path.join(config.path, 'platforms/android/platform_www')]
			startPath: '/index.html'
			browser: 'default'
			open: no
			ui: no
			ghostMode: no # disable syncing across browser instances
			online: no
			notify: yes
		, (err) -> if err? then $.handleStreamError(err) else cb()

	gulp.task 'cordova:dev:port-forwarding', () ->
		gulp.src('')
		.pipe $.shell('adb reverse tcp:8080 tcp:3000')


	gulp.task 'cordova:android:serve', (cb) ->
		$.runSequence 'web:clean', 'web:dev:watch', 'cordova:browser-sync', 'cordova:dev:port-forwarding', 'cordova:android:run', cb

module.exports = ({gulp, $, config}) ->

	if config.path? #in case cordova is not configured in package.json
		ftpConfig = config?.deploy?.ftp

	# Uploads .ipa files found in the release directory to an FTP
	# server location that must be specified in gulp-angular-config.js.
	gulp.task 'cordova:ios:deploy', ->
		unless ftpConfig?
			return $.util.warn 'no ftp data given in config'
		gulp.src $.path.join(config.path, 'release/*.ipa')
			.pipe $.ftp ftpConfig
			.pipe $.util.noop()

	# Uploads .apk files found in the release directory to an FTP
	# server location that must be specified in gulp-angular-config.js.
	gulp.task 'cordova:android:deploy', ->
		unless ftpConfig?
			return $.util.warn 'no ftp data given in config'
		gulp.src $.path.join(config.path, 'release/*.apk')
			.pipe $.ftp ftpConfig
			.pipe $.util.noop()

	# Uploads .ipa and .apk files found in the release directory to an FTP
	# server location that must be specified in gulp-angular-config.js.
	gulp.task 'cordova:ios:build-deploy', (cb) -> $.runSequence 'cordova:ios:build', 'cordova:ios:deploy', cb
	gulp.task 'cordova:android:build-deploy', (cb) -> $.runSequence 'cordova:android:build', 'cordova:android:deploy', cb
	gulp.task 'cordova:deploy', ['cordova:ios:deploy', 'cordova:android:deploy']

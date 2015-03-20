module.exports = (gulp, $) ->
	cordovaConfig = $.packageJson['gulp-angular']?.cordova
	path = cordovaConfig?.build?.path
	if path? #in case cordova is not configured in package.json
		ftpConfig = cordovaConfig.deploy?.ftp

	# Uploads .ipa files found in the release directory to an FTP
	# server location that must be specified in gulp-angular-config.js.
	gulp.task 'cordova:deploy:ios', ->
		gulp.src $.path.join(path, 'release/*.ipa')
			.pipe $.ftp ftpConfig
			.pipe $.util.noop()

	# Uploads .apk files found in the release directory to an FTP
	# server location that must be specified in gulp-angular-config.js.
	gulp.task 'cordova:deploy:android', ->
		gulp.src $.path.join(path, 'release/*.apk')
			.pipe $.ftp ftpConfig
			.pipe $.util.noop()

	# Uploads .ipa and .apk files found in the release directory to an FTP
	# server location that must be specified in gulp-angular-config.js.
	gulp.task 'cordova:deploy', ['cordova:deploy:ios', 'cordova:deploy:android']

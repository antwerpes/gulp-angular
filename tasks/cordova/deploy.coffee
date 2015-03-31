module.exports = ({gulp, $, config}) ->

	if config.path? #in case cordova is not configured in package.json
		ftpConfig = config?.deploy?.ftp

	# Uploads .ipa files found in the release directory to an FTP
	# server location that must be specified in gulp-angular-config.js.
	gulp.task 'cordova:deploy:ios', ->
		unless ftpConfig?
			return $.util.warn 'no ftp data given in config'
		gulp.src $.path.join(config.path, 'release/*.ipa')
			.pipe $.ftp ftpConfig
			.pipe $.util.noop()

	# Uploads .apk files found in the release directory to an FTP
	# server location that must be specified in gulp-angular-config.js.
	gulp.task 'cordova:deploy:android', ->
		unless ftpConfig?
			return $.util.warn 'no ftp data given in config'
		gulp.src $.path.join(config.path, 'release/*.apk')
			.pipe $.ftp ftpConfig
			.pipe $.util.noop()

	# Uploads .ipa and .apk files found in the release directory to an FTP
	# server location that must be specified in gulp-angular-config.js.
	gulp.task 'cordova:deploy', ['cordova:deploy:ios', 'cordova:deploy:android']

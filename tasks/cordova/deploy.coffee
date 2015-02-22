module.exports = (gulp, $) ->
	ftpConfig =
		host: $.ftp.hostname
		user: $.ftp.username
		pass: $.ftp.password
		remotePath: $.ftp.directory

	# Uploads .ipa files found in the release directory to an FTP
	# server location that must be specified in gulp-angular-config.js.
	gulp.task 'cordova:deploy:ios', ->
		gulp.src 'release/*.ipa'
			.pipe $.ftp ftpConfig
			.pipe $.util.noop()

	# Uploads .apk files found in the release directory to an FTP
	# server location that must be specified in gulp-angular-config.js.
	gulp.task 'cordova:deploy:android', ->
		gulp.src 'release/*.apk'
			.pipe $.ftp ftpConfig
			.pipe $.util.noop()

	# Uploads .ipa and .apk files found in the release directory to an FTP
	# server location that must be specified in gulp-angular-config.js.
	gulp.task 'cordova:deploy', ['cordova:deploy:ios', 'cordova:deploy:android']

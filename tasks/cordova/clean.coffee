module.exports = (gulp, $) ->

	# Deletes iOS specific files from the release directory
	# (`*.ipa, *dSYM.zip, *.xcarchive`).
	gulp.task 'cordova:clean:ios', (cb) ->
		$.del 'release/*.{ipa,dSYM.zip,xcarchive}', cb

	# Deletes Android specific files from the release
	# directory (`*.apk`).
	gulp.task 'cordova:clean:android', (cb) ->
		$.del 'release/*.apk', cb

	# Deletes iOS and Android specific files from the release
	# directory (`*.ipa, *dSYM.zip, *.xcarchive, *.apk`),
	# leaving other files and the directory itself in place.
	gulp.task 'cordova:clean', ['cordova:clean:ios', 'cordova:clean:android']

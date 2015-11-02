module.exports = ({gulp, $, config}) ->

	# Deletes iOS specific files from the release directory
	# (`*.ipa, *dSYM.zip, *.xcarchive`).
	gulp.task 'cordova:ios:clean', () ->
		if config.path? and config.path.indexOf('/') != 0
			$.del $.path.join(config.path, 'release/*.{ipa,dSYM.zip,xcarchive}')
		else
			console.log 'won\'t delete something that starts with slash'

	# Deletes Android specific files from the release
	# directory (`*.apk`).
	gulp.task 'cordova:android:clean', () ->
		if config.path? and config.path.indexOf('/') != 0
			$.del $.path.join(config.path, 'release/*.apk')
		else
			console.log 'won\'t delete something that starts with slash'

	# Deletes iOS and Android specific files from the release
	# directory (`*.ipa, *dSYM.zip, *.xcarchive, *.apk`),
	# leaving other files and the directory itself in place.
	gulp.task 'cordova:clean', ['cordova:ios:clean', 'cordova:android:clean']

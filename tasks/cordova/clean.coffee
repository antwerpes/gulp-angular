module.exports = ({gulp, $, config}) ->

	# Deletes iOS specific files from the release directory
	# (`*.ipa, *dSYM.zip, *.xcarchive`).
	gulp.task 'cordova:clean:ios', (cb) ->
		if config.path? and config.path.indexOf('/') != 0
			$.del $.path.join(config.path, 'release/*.{ipa,dSYM.zip,xcarchive}'), cb
		else
			console.log 'won\'t delete something that starts with slash'

	# Deletes Android specific files from the release
	# directory (`*.apk`).
	gulp.task 'cordova:clean:android', (cb) ->
		if config.path? and config.path.indexOf('/') != 0
			$.del $.path.join(config.path, 'release/*.apk'), cb
		else
			console.log 'won\'t delete something that starts with slash'

	# Deletes iOS and Android specific files from the release
	# directory (`*.ipa, *dSYM.zip, *.xcarchive, *.apk`),
	# leaving other files and the directory itself in place.
	gulp.task 'cordova:clean', ['cordova:clean:ios', 'cordova:clean:android']

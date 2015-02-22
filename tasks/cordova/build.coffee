# TODO: read cordova project name from config.xml instead of gulp-angular-config.js

module.exports = (gulp, $) ->

	# Builds a production-/distribution-ready iOS
	# app to the release directory.
	# - Generates an .ipa and an .xcarchive file.
	# - Reads a `config` object from gulp-angular-config.js.
	# - Takes `config.appName` as the base filename for output
	#   files and for Xcode build scheme selection. This name
	#   must exactly match the cordova project name in config.xml.
	# - Signs the app with the provisioning profile named
	#   in `config.ios.provisioningProfile`.
	gulp.task 'cordova:build:ios', ['cordova:clean:ios'], ->
		gulp.src('').pipe $.shell [
			'mkdir -p release'
			'cordova prepare'
			'cd platforms/ios; xcodebuild clean -project ' + $.config.appName + '.xcodeproj -configuration Release -alltargets'
			'cd platforms/ios; xcodebuild archive -project ' + $.config.appName + '.xcodeproj -scheme ' + $.config.appName + ' -archivePath ' + $.config.appName + '.xcarchive'
			'cd platforms/ios; xcodebuild -exportArchive -archivePath ' + $.config.appName + '.xcarchive -exportPath ' + $.config.appName + ' -exportFormat ipa -exportProvisioningProfile "' + $.config.ios.provisioningProfile + '"'
			'mv platforms/ios/' + $.config.appName + '.xcarchive release/'
			'mv platforms/ios/' + $.config.appName + '.ipa release/'
			#'ipa info release/' + $.config.appName + '.ipa' # outputs a nice overview, but requires shenzhen to be installed
		]

	# Builds a production-/distribution-ready Android
	# app (.apk file) into the release directory.
	# Configuration of app signing must be performed separately
	# e.g. via a custom after_platform_add cordova hook.
	gulp.task 'cordova:build:android', ['cordova:clean:android'], ->
		gulp.src('').pipe $.shell [
			'cordova build android --release'
			'mkdir -p release'
			'mv platforms/android/ant-build/CordovaApp-release.apk release/' + $.config.appName + '.apk'
		]

	# Builds production-/distribution-ready iOS
	# and Android apps into the release directory.
	gulp.task 'cordova:build', ['cordova:build:ios', 'cordova:build:android']

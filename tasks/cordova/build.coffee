# TODO: read cordova project name from config.xml instead of gulp-angular-config.js

module.exports = (gulp, $) ->
	path = $.packageJson['gulp-angular']?.cordova?.build?.path
	if path? #in case cordova is not configured in package.json

		configXMLAbsolutePath = $.path.join process.cwd(), path, 'config.xml'
		if $.fs.existsSync(configXMLAbsolutePath)
			configXML = $.fs.readFileSync(configXMLAbsolutePath,'ascii')
			appName = '"' + $.xml2json.toJson(configXML, object: yes).widget.name + '"'
	
	# Builds a production-/distribution-ready iOS
	# app to the release directory.
	# - Generates an .ipa and an .xcarchive file.
	# - Reads a `config` object from gulp-angular-config.js.
	# - Takes `config.appName` as the base filename for output
	#   files and for Xcode build scheme selection. This name
	#   must exactly match the cordova project name in config.xml.
	# - Signs the app with the provisioning profile named
	#   in `config.ios.provisioningProfile`.
	gulp.task 'cordova:build:ios', ['cordova:clean:ios'], (cb) ->
		provisioningProfile = $.packageJson['gulp-angular']?.cordova?.build?.ios?.provisioningProfile
		unless appName
			$.util.log 'no app-name given at package.json: gulp-angular.cordova.build.appName'
			return cb()
		unless $.fs.existsSync(path)
			$.util.log 'the given path doens\'t exist. make sure "path" points to a cordova project directory'
			return cb()
		unless path
			$.util.log 'no path given at package.json: gulp-angular.cordova.build.path'
			return cb()
		gulp.src('').pipe $.shell [
			'mkdir -p release'
			'cordova prepare'
			'cd platforms/ios; xcodebuild clean -project ' + appName + '.xcodeproj -configuration Release -alltargets'
			'cd platforms/ios; xcodebuild archive -project ' + appName + '.xcodeproj -scheme ' + appName + ' -archivePath ' + appName + '.xcarchive'
			'cd platforms/ios; xcodebuild -exportArchive -archivePath ' + appName + '.xcarchive -exportPath ' + appName + ' -exportFormat ipa -exportProvisioningProfile "' + provisioningProfile + '"'
			'mv platforms/ios/' + appName + '.xcarchive release/'
			'mv platforms/ios/' + appName + '.ipa release/'
			#'ipa info release/' + appName + '.ipa' # outputs a nice overview, but requires shenzhen to be installed
		], cwd: path

	# Builds a production-/distribution-ready Android
	# app (.apk file) into the release directory.
	# Configuration of app signing must be performed separately
	# e.g. via a custom after_platform_add cordova hook.
	gulp.task 'cordova:build:android', ['cordova:clean:android'], (cb) ->
		unless appName
			$.util.log 'no app-name given at package.json: gulp-angular.cordova.build.appName'
			return cb()
		unless path
			$.util.log 'no path given at package.json: gulp-angular.cordova.build.path'
			return cb()
		gulp.src('').pipe $.shell [
			'cordova build android --release'
			'mkdir -p release'
			'mv platforms/android/ant-build/CordovaApp-release.apk release/' + appName + '.apk'
		], cwd: path

	# Builds production-/distribution-ready iOS
	# and Android apps into the release directory.
	gulp.task 'cordova:build', ['cordova:build:ios', 'cordova:build:android']

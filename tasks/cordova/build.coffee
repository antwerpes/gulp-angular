# TODO: read cordova project name from config.xml instead of gulp-angular-config.js

module.exports = ({gulp, $, config}) ->
	configXMLAbsolutePath = $.path.join process.cwd(), config.path, 'config.xml'
	if $.fs.existsSync(configXMLAbsolutePath)
		configXML = $.fs.readFileSync(configXMLAbsolutePath,'ascii')
		appName = '"' + $.xml2json.toJson(configXML, object: yes).widget.name + '"'
	else
		return
	underscoredAppName = appName.replace(/\s+/g, '_')

	# Builds a production-/distribution-ready iOS
	# app to the release directory.
	# - Generates an .ipa and an .xcarchive file.
	# - Signs the app with the provisioning profile named
	#   in `config.ios.provisioningProfile`.
	gulp.task 'cordova:ios:build', ['cordova:ios:clean'], (cb) ->
		provisioningProfile = config.ios?.provisioningProfile
		codeSigningIdentity = config.ios?.codeSigningIdentity
		unless appName
			$.util.log 'no app-name given at package.json: gulp-angular.cordova.build.appName'
			return cb()
		unless $.fs.existsSync(config.path)
			$.util.log 'the given path doens\'t exist. make sure "path" points to a cordova project directory'
			return cb()
		unless config.path
			$.util.log 'no path given at package.json: gulp-angular.cordova.build.path'
			return cb()

		cmds = [
			'mkdir -p release'
			'cordova prepare'
			'cd platforms/ios; xcodebuild clean -project ' + appName + '.xcodeproj -configuration Release -alltargets'
			'cd platforms/ios; xcodebuild archive -project ' + appName + '.xcodeproj -scheme ' + appName + ' -archivePath ' + appName + '.xcarchive'
			'cd platforms/ios; xcodebuild -exportArchive -archivePath ' + appName + '.xcarchive -exportPath ' + appName + ' -exportFormat ipa -exportProvisioningProfile "' + provisioningProfile + '"'
			#'ipa info release/' + appName + '.ipa' # outputs a nice overview, but requires shenzhen to be installed
		]

		if codeSigningIdentity
			cmds.push 'cd platforms/ios; codesign -f --sign ' + codeSigningIdentity + ' ' + appName + '.ipa'

		cmds.push 'mv platforms/ios/' + appName + '.xcarchive release/' + underscoredAppName + '.xcarchive'
		cmds.push 'mv platforms/ios/' + appName + '.ipa release/' + underscoredAppName + '.ipa'

		gulp.src('').pipe $.shell cmds, cwd: config.path


	# Builds a production-/distribution-ready Android
	# app (.apk file) into the release directory.
	# Configuration of app signing must be performed separately
	# e.g. via a custom after_platform_add cordova hook.
	gulp.task 'cordova:android:build', ['cordova:android:clean'], (cb) ->
		unless appName
			$.util.log 'no appName for building android given in config'
			return cb()
		unless config.path
			$.util.log 'no path for building android given in config'
			return cb()
		unless config.android?.sign?
			$.util.log 'no signing information for building android given in config'
			return cb()

		# Write signing config into ant.properties:
		gradleSignConfig = ''
		gradleSignConfig += "#{key}=#{value}\n" for key, value of config.android.sign
		fs = require('fs')

		fs.writeFileSync $.path.join(config.path, 'platforms/android/release-signing.properties'), gradleSignConfig
		buildCommand = [
			'cordova build android --release'
			'mkdir -p release'
			# Work around https://issues.apache.org/jira/browse/CB-7827
			# || true prevents a missing file from stopping execution
			# 'mv platforms/android/ant-build/CordovaApp-release.apk release/' + underscoredAppName + '.apk || true'
			# 'mv platforms/android/ant-build/MainActivity-release.apk release/' + underscoredAppName + '.apk || true'
		]
		gulp.src('').pipe $.shell buildCommand, cwd: config.path


	# Builds production-/distribution-ready iOS
	# and Android apps into the release directory.
	gulp.task 'cordova:build', ['cordova:ios:build', 'cordova:android:build']

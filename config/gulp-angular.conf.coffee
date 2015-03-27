module.exports =
	angularModuleName:
		doc: 'Name of your Main Angular-Module. Used for ng-annotate and Scaffolding'
		format: '*'
		default: null
	core:
		copyBowerAssets:
			doc: 'copy these folders from the bower component to dist. Expects an Object with the module as property and the directory as value'
			default: null
	cordova:
		path:
			doc: 'destination path for the cordova project'
			default: 'cordova'
			format: '*'
		ios:
			provisioningProfile:
				doc: 'the name as it appears in the xCode Build Settings'
				format: '*'
				default: null
		android:
			sign:
				doc: 'signing information for building the Android apk. see README.md for Format specification'
				format: (val) ->
					return Array.isArray(val) or val is null
				default: null
		deploy:
			ftp:
				host:
					format: 'url'
					default: 'your-host-here.io'
				user:
					format: '*'
					default: null
				pass:
					format: '*'
					default: null
				remotePath:
					format: '*'
					default: null
	component:
		noop: 'noop'
		# TODO
	nwjs:
		# see options at https://github.com/mllrsohn/node-webkit-builder
		appName:
			default: 'NWJS App'
		appVersion:
			default: 'v0.0.0'
		macIcns:
			default: 'src/icon.icns'
		winIco:
			default: 'src/icon.ico'
		platforms:
			format: (value) ->
				return no unless Array.isArray(value)
				platformAllowed = yes
				for val in value
					unless val in ['win32', 'win64', 'osx32', 'osx64', 'linux32', 'linux64']
						platformAllowed = no
				return platformAllowed
			default: ['osx64']
		version:
			default: 'latest'
		buildDir:
			default: 'node-webkit'
		cacheDir:
			default: '.node-webkit-cache'
		files:
			default: 'dist/**/*'
		dev:
			packageOverrides:
				format: '*'
				default: {}
	create:
		jade:
			format: (val) -> return !!val
			default: true



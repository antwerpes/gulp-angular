module.exports =
	angularModuleName:
		doc: 'Name of your Main Angular-Module. Used for ng-annotate and Scaffolding'
		format: '*'
		default: null
	web:
		copyBowerAssets:
			doc: 'copy these folders from the bower component to dist. Expects an Object with the module as property and the directory as value'
			format: (val) ->
				return not val? or val is '[object Object]'
			default: null
		sourcemaps:
			doc: 'Minified code will have sourcemaps'
			default: no
	cordova:
		path:
			doc: 'destination path for the cordova project'
			default: 'cordova'
			format: '*'
		plugins:
			doc: 'cordova plugins to be installed after platform projects are generated'
			default: []
			format: (value) -> return Array.isArray value
		ios:
			provisioningProfile:
				doc: 'the name as it appears in the xCode Build Settings'
				format: '*'
				default: null
		android:
			sign:
				'key.store':
					doc: 'relative path to the keystore file used for signing android apk files'
					format: '*'
					default: null
				'key.store.password':
					doc: 'password to unlock the keystore file used for signing android apk files'
					format: '*'
					default: null
				'key.alias':
					doc: 'alias to unlock the keystore file used for signing android apk files'
					format: '*'
					default: null
				'key.alias.password':
					doc: 'alias password to unlock the keystore file used for signing android apk files'
					format: '*'
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
	test:
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



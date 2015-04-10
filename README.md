# gulp-angular

A collection of gulp tasks for developing angular applications and deploying them to the Web, Cordova and Node-Webkit containers.

## Getting Started
To bootstrap a project using gulp-angular you need to take the following steps:

- initialize a your Project as a node-module with `npm init`
- install gulp and gulp-angular with `npm install --save-dev gulp && npm install --save-dev antwerpes/gulp-angular`
- create a minimal gulpfile.js with the following contents:

```javascript
'use strict';

var gulp = require('gulp');

var gulpAngularConfig = {
	// the module name is the only required parameter. 
	// For more see config/config.example.json or config/gulp-angular.conf.coffee
  "angularModuleName": 'MyApp' 
}

require('gulp-angular')(gulp, gulpAngularConfig);
```
- run `gulp create:project` to generate the basic app structure
- run `bower install` to install angular.js

#### Most used Tasks.
Task | Description
---- | -----------
`web:serve` | Builds and serves a clean development version of the web app from `tmp/` while watching for source file changes to live-inject css or reload the app for template and script changes.
`build` | Builds production-ready versions of the app for the Web, as iOS and Android Cordova Apps and as Node-Webkit App.
`deploy` | Uploads the production ready Apps to ftp servers
`build-and-deploy` | Builds and Uploads the production ready Apps to ftp servers. 

##### Development

Task | Description
---- | -----------
`web:serve` | Builds and serves a clean development version of the web app from `tmp/` while watching for source file changes to live-inject css or reload the app for template and script changes.
`web:serve:dist` | analog to `web:serve` but with a minified, concatenated and obfuscated production-ready build.
`nwjs:serve` | Analogous to `web:serve` but inside a Node-Webkit container.
`nwjs:serve:dist` | Analogous to `web:serve:dist`
`cordova:serve:ios` | Builds an iOS cordova app and updates the sources via `cordova prepare` when they change (App re-run is required to see changes)
`cordova:serve:android` | Idem for Android
`cordova:serve:dist:ios` | Idem but with a production-ready version
`cordova:serve:dist:android` | For Android

##### Build

Task | Description
---- | -----------
`web:build` | Builds a clean production-ready version of the web app to dist/.
`nwjs:build` | Idem but inside a Node-Webkit Container.
`cordova:build` | Idem but inside a Cordova Container for both iOS and Android.
`cordova:build:ios` | Idem but only iOS.
`cordova:build:android` | Idem but only Android.
`web:build` | Builds a clean production-ready version of the web app to dist/.
`web:serve:dist` | analog to `web:serve` but with a minified, concatenated and obfuscated production-ready build.
`nwjs:serve` | Analogous to `web:serve` but inside a Node-Webkit container.
`nwjs:serve:dist` | Analogous to `web:serve:dist`
`cordova:serve:ios` | Builds a cordova app and updates the sources via `cordova prepare` when they change
`cordova:serve:android` | Idem but on Android
`cordova:serve:dist:ios` | Idem but with production ready-version
`cordova:serve:dist:android` | Analogous to `web:serve:dist`

### Scaffolding

Task | Description | Options
---- | ----------- | -------
`create:app` | Generates all neccesary scaffolding for a new app
`create:controller` | Generates a controller with tests and template | `--here`: the controller will be placed in your current working dir, `--jade` create a jade template instead of coffeescript
`create:directive` | Generates a directive and template | see controller
`create:service` | Generates a Service | `--here`: the service will be placed in your current working dir
`create:factory` | Generates a Factory | see service
`create:provider` | Generates a Provider | see service
`create:filter` | Generates a Filter | see service

- For options in nwjs builder (/package.json/gulp-angular-config/webkit) see options in https://github.com/mllrsohn/node-webkit-builder

Task | Description
---- | -----------
`webkit:build` | Builds project and generates node-webkit app
`webkit:build:copy-dist` | Generates node-webkit app with contents of dist without building

### Cordova

#### Prerequisites

- If used together with the web module, make the cordova www directory a symlink to the dist directory.
- Your project needs to be a valid cordova project that has a config.xml file, www and hooks directories.
- Optionally a cordova hook script that runs 'after_platform_add' for configuring the android project to generate signed apk files (see below).

##### Setup the Cordova Project
```bash
cordova create path/to/cordova de.bundle.identifier appname
```

the '.' is important as it will make the current project a cordova app 

##### /package.json (example)
```json
{
	...
	"gulp-angular": {
		"cordova": {
			"build": {
				"appName": "", /* same value as the <name> field inside config.xml */
				"ftp": { /* used to publish ipa and apk files to an FTP server */
					"hostname": "",
					"username": "",
					"password": "",
					"directory": ""
				},
				"ios": { /* used for building signed ipa files */
					"provisioningProfile": "" /* name as it appears in Xcode build settings */
				},
				"android": { /* used for building signed apk files */
					"sign": [ /* text will be copied into platforms/android/ant.properties */
						"key.store=", /* path to exported keystore file */
						"key.store.password=",
						"key.alias=",
						"key.alias.password="
					]
				}
			}
		},
		...
	}
}
```

#### Tasks

Task | Description
---- | -----------
`cordova:init` | Generates Cordova iOS and Android platform projects by simply executing `cordova platform add ios` and `cordova platform add android` shell commands. Depends on `cordova:destroy`.
`cordova:destroy` | Deletes any cordova related output directories like plugins, platforms and release (that can be regenerated at any time).
`cordova:clean:ios` | Deletes iOS specific files from the release directory (`*.ipa, *dSYM.zip, *.xcarchive`).
`cordova:clean:android` | Deletes Android specific files from the release directory (`*.apk`).
`cordova:clean` | Deletes iOS and Android specific files from the release directory (`*.ipa, *dSYM.zip, *.xcarchive, *.apk`), leaving other files and the directory itself in place. Depends on `cordova:clean:ios`, `cordova:clean:android`.
`cordova:build:ios` | Builds a production-/distribution-ready iOS app to the release directory.<br />- Generates an .ipa and an .xcarchive file.<br />- Reads a `config` object from gulp-angular-config.js.<br />- Takes `config.appName` as the base filename for output files and for Xcode build scheme selection. This name must exactly match the cordova project name in config.xml.<br />- Signs the app with the provisioning profile named in `config.ios.provisioningProfile`. Depends on `cordova:clean:ios`.
`cordova:build:android` | Builds a production-/distribution-ready Android app (.apk file) into the release directory. Depends on `cordova:clean:android`.
`cordova:build` | Builds production-/distribution-ready iOS and Android apps into the release directory. Depends on `cordova:build:ios`, `cordova:build:android`.
`cordova:deploy:ios` | Uploads .ipa files found in the release directory to an FTP server location that must be specified in gulp-angular-config.js.
`cordova:deploy:android` | Uploads .apk files found in the release directory to an FTP server location that must be specified in gulp-angular-config.js.
`cordova:deploy` | Uploads .ipa and .apk files found in the release directory to an FTP server location that must be specified in gulp-angular-config.js. Depends on `cordova:deploy:ios`, `cordova:deploy:android`.
`cordova:run:ios` | Runs the iOS platform project on the currently plugged-in device. Requires 'ios-deploy' node module to be installed globally.
`cordova:run:android` | Runs the Android platform project on the currently plugged-in device.

### Development

```bash
cd /path/to/projects/folder
git clone git+ssh://git@github.com/antwerpes/gulp-angular.git
cd gulp-angular
npm link
cd /path/to/project/using/gulp-angular
npm link gulp-angular
```

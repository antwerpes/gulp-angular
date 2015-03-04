# gulp-angular

A collection of gulp tasks for developing angular applications.

## Installation

When just consuming:

```bash
npm install --save-dev antwerpes/gulp-angular
```

When consuming and developing it further:

```bash
cd /path/to/projects/folder
git clone git+ssh://git@github.com/antwerpes/gulp-angular.git
npm link
cd /path/to/project/using/gulp-angular
echo add "gulp-angular": "git+ssh://git@github.com:antwerpes/gulp-angular" to devDependencies in package.json
npm link gulp-angular
```

## Usage

Require all modules/task collections:

```javascript
var gulp = require('gulp');
require('gulp-angular')(gulp);
```

Require a specific module/task collection selectively:
```javascript
var gulp = require('gulp');
require('gulp-angular/tasks/cordova')(gulp);
```

## Modules/Task Collections

### Core

#### Prerequisites

##### /src/index.html:
```html
<!doctype html>
<html>
  <head>
	<!-- build:css({tmp,src}) styles/vendor.css -->
		<!-- bower:css -->
			<!-- STYLES FROM BOWER_COMPONENTS WILL BE AUTOMATICALLY INJECTED HERE -->
		<!-- endbower -->
	<!-- endbuild -->

	<!-- build:css({tmp,src}) styles/main.css -->
		<!-- inject:styles -->
			<!-- OWN STYLES WILL BE AUTOMATICALLY INJECTED HERE -->
		<!-- endinject -->
	<!-- endbuild -->
  </head>
  <body>
	<div ui-view class="rootView"></div>
	<!-- build:js scripts/vendor.js -->
		<!-- bower:js -->
			<!-- SCRIPTS FROM BOWER_COMPONENTS WILL BE AUTOMATICALLY INJECTED HERE -->
		<!-- endbower -->
	<!-- endbuild -->

	<!-- build:js scripts/main.js -->
		<!-- inject:scripts -->
			<!-- OWN SCRIPTS WILL BE AUTOMATICALLY INJECTED HERE -->
		<!-- endinject -->
		<!-- inject:partials -->
			<!-- OWN ANGULAR TEMPLATES WILL BE AUTOMATICALLY INJECTED HERE -->
		<!-- endinject -->
	<!-- endbuild -->
  </body>
</html>
```
##### /gulpfile.js
```js
var gulp = require('gulp');
var config = {}
var packageJson = require('./package.json');

require('gulp-angular')(gulp, config, packageJson);
```

##### /.bowerrc
```js
{
	"directory": "src/bower_components"
}
```

#### Tasks

Task | Description
---- | -----------
`core:clean` | Deletes tmp and empties the dist directory leaving the directory itself intact so that symlinks pointing to it (e.g. cordova www) don't break.
`core:transpile:styles` | Transpiles less and sass files found in src into css files copied to tmp. Automatically adds vendor prefixes after transpilation.
`core:transpile:scripts` | Transpiles coffee files found in src into js files copied to tmp. Lints coffeescript and converts coffeescript classes to angular syntax (ng-classify) before transpilation. Sourcemaps are not supported yet.
`core:transpile` | Transpiles styles and scripts from src to tmp. Depends on `core:transpile:styles` and `core:transpile:scripts`.
`core:inject` | Injects file references of css and js files found in src and tmp into tmp/index.html. Copies src/index.html over to tmp while injecting references of css and js source files found in src and tmp into `<!-- inject:* -->` blocks. Because we want to overwrite bootstrap styles in vendor.css, we @import them over there and don't inject them here. Depends on `core:transpile`.
`core:watch` | Watches bower.json and triggers inject when its content changes. Watches less, sass and coffeescript files in src (not bower components) and triggers retranspilation when their content changes. New files are being transpiled and injected into tmp/index.html. Counterparts in tmp of files being deleted from src are also being deleted with inject being triggered afterwards. Depends on `core:inject` and starts `core:transpile:styles`, `core:transpile:scripts`, `core:inject` when watcher triggers changes.
`core:serve:browser-sync:dev` | Starts a local web server serving the development version of the web app. Serves files from both the tmp and the src directories. Files in tmp have precedence over those found in src, which is especially important in order to ensure that the injected version of index.html gets served.
`core:serve:browser-sync:dist` | Starts a local web server serving the production-/distribution-ready version of the web app from the dist directory.
`core:serve:dev` | Builds and serves a clean development version of the web app while watching for source file changes. Runs `core:clean`, `core:watch`, `core:serve:browser-sync:dev` in sequence.
`core:serve:dist` | Starts a local web server serving the production-/distribution-ready version of the web app. Runs `core:build`, `core:serve:browser-sync:dist` in sequence.
`core:build:images` | Optimizes and copies images from src to dist, ignoring images found in bower components.
`core:build:fonts` | Copies fonts from src to dist, including those found in bower components.
`core:build:partials` | Minifies and packages html templates/partials found in src into pre-cached angular template modules in dist.
`core:build-prepare` | When building a production-/distribution-ready version of the web app, all html, css and js files being present in src and tmp need further processing. This pre-build task ensures that from now on, changes are being made on copies of the original files so that building dist has no side effect on files that are already present in src or have been generated into tmp for development purposes (e.g. we don't want partials to be injected into tmp/index.html, which would mess up `core:serve:dev`). The task does three things:<br />1) Copies index.html from tmp to dist.<br />2) Copies those css files that are referenced in tmp/index.html (within `<!--  build:css -->` blocks) to dist while rebasing all urls found in their css rules. Rebasing takes place with respect to the location of the final, concatenated css files that are yet to be generated in the following `core:build-build` task<br />3) Copies those js files that are referenced in tmp/index.html (within `<!-- build:js -->` blocks) to dist, leaving their content untouched.
`core:build-build` | Performs the actual minification and concatenation of html, css and js files, resulting in a production-/distribution-ready version of the web app in dist. Depends on `core:build-prepare`.
`core:build-cleanup` | Deletes those css and js files from dist that were generated by the `core:build-prepare` task and leaves the dist directory in a clean state without any remaining empty directories.
`core:build` | Builds a production-/distribution-ready version of the web app into the dist directory. Runs `core:clean`, [`core:inject`, `core:build:images`, `core:build:fonts`, `core:build:partials` in parallel], `core:build-build`, `core:build-cleanup` in sequence.

### Webkit

#### Prerequisites
TODO work in progress
- /src/package.json in with `main: "index.html"`
- configuration in /package.json/gulp-angular-config/webkit (see options in https://github.com/mllrsohn/node-webkit-builder)

Task | Description
---- | -----------
`webkit:build` | Builds project and generates node-webkit app
`webkit:build:copy-dist` | Generates node-webkit app with contents of dist without building

### Cordova

#### Prerequisites

- If used together with the core module, make the cordova www directory a symlink to the dist directory.
- Your project needs to be a valid cordova project that has a config.xml file, www and hooks directories.
- Existence of gulp-angular-config.js file in the root of your project (see below).
- Optionally a cordova hook script that runs 'after_platform_add' for configuring the android project to generate signed apk files (see below).

##### /gulpfile.js
```js
var gulp = require('gulp');
var config = {
	...
	appName: '', /* same value as the <name> field inside config.xml */
	ftp: { /* used to publish ipa and apk files to an FTP server */
		hostname: '',
		username: '',
		password: '',
		directory: ''
	},
	ios: { /* used for building signed ipa files */
		provisioningProfile: '' /* name as it appears in Xcode build settings */
	},
	android: { /* used for building signed apk files */
		sign: [ /* text will be copied into platforms/android/ant.properties */
			'key.store=', /* path to exported keystore file */
			'key.store.password=',
			'key.alias=',
			'key.alias.password='
		]
	},
	...
}
var packageJson = require('./package.json');

require('gulp-angular')(gulp, config, packageJson);
```

##### /hooks/after_platform_add/configure_android_keys.js
```javascript
#!/usr/bin/env node

var fs = require('fs');

if (!fs.existsSync('platforms/android')) return;

var config = require('../../gulp-angular-config.js');

var stream = fs.createWriteStream('platforms/android/ant.properties');
stream.once('open', function() {
	config.android.sign.forEach(function (line) {
		stream.write(line + '\n');
	});
  stream.end();
});
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
`cordova:build:android` | Builds a production-/distribution-ready Android app (.apk file) into the release directory. Configuration of app signing must be performed separately e.g. via a custom after_platform_add cordova hook. Depends on `cordova:clean:android`.
`cordova:build` | Builds production-/distribution-ready iOS and Android apps into the release directory. Depends on `cordova:build:ios`, `cordova:build:android`.
`cordova:deploy:ios` | Uploads .ipa files found in the release directory to an FTP server location that must be specified in gulp-angular-config.js.
`cordova:deploy:android` | Uploads .apk files found in the release directory to an FTP server location that must be specified in gulp-angular-config.js.
`cordova:deploy` | Uploads .ipa and .apk files found in the release directory to an FTP server location that must be specified in gulp-angular-config.js. Depends on `cordova:deploy:ios`, `cordova:deploy:android`.
`cordova:run:ios` | Runs the iOS platform project on the currently plugged-in device. Requires 'ios-deploy' node module to be installed globally.
`cordova:run:android` | Runs the Android platform project on the currently plugged-in device.

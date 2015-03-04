$ =
	handleStreamError: require '../../helper/handle-stream-error'
	del:               require 'del'
	changed:           require 'gulp-changed'
	angularFileSort:   require 'gulp-angular-filesort'
	if:                require 'gulp-if'
	less:              require 'gulp-less'
	jade:              require 'gulp-jade'
	util:              require 'gulp-util'
	autoprefixer:      require 'gulp-autoprefixer'
	size:              require 'gulp-size'
	ngClassify:        require 'gulp-ng-classify'
	coffeelint:        require 'gulp-coffeelint'
	coffee:            require 'gulp-coffee'
	wiredep:           require 'wiredep'
	inject:            require 'gulp-inject'
	gracefulChokidar:  require 'graceful-chokidar'
	path:              require 'path'
	browserSync:       require 'browser-sync'
	imagemin:          require 'gulp-imagemin'
	mainBowerFiles:    require 'main-bower-files'
	filter:            require 'gulp-filter'
	merge:             require 'gulp-merge'
	minifyHtml:        require 'gulp-minify-html'
	ngHtml2js:         require 'gulp-ng-html2js'
	rename:            require 'gulp-rename'
	lazypipe:          require 'lazypipe'
	copy:              require 'gulp-copy'
	cssretarget:       require 'gulp-cssretarget'
	useref:            require 'gulp-useref'
	minifyCss:         require 'gulp-minify-css'
	ngAnnotate:        require 'gulp-ng-annotate'
	uglify:            require 'gulp-uglify'
	uglifySaveLicense: require 'uglify-save-license'
	rev:               require 'gulp-rev'
	revReplace:        require 'gulp-rev-replace'
	fs:                require 'fs'
	mergeStream:			 require 'merge-stream'
	ignore:						 require 'gulp-ignore'

try $.sass = require 'gulp-sass'
catch e
	console.warn 'sass not available'
	$.sass = $.util.noop

module.exports = (gulp, config, packageJson) ->
	$.config = config
	$.packageJson = packageJson
	$.runSequence = require('run-sequence').use(gulp)
	require(task)(gulp, $) for task in [
		'./clean'
		'./transpile'
		'./inject'
		'./watch'
		'./serve'
		'./build'
		'./bower-assets'
	]

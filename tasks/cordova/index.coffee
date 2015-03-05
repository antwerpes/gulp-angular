$ =
	del:    require 'del'
	shell:  require 'gulp-shell'
	ftp:    require 'gulp-ftp'
	util:   require 'gulp-util'
	fs:			require 'fs'
	path:		require 'path'

module.exports = (gulp, packageJson) ->
	$.packageJson = packageJson
	require(task)(gulp, $) for task in [
		'./init-destroy'
		'./clean'
		'./build'
		'./run'
		'./deploy'
	]

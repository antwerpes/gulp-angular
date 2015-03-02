$ =
	del:    require 'del'
	shell:  require 'gulp-shell'
	ftp:    require 'gulp-ftp'
	util:   require 'gulp-util'

module.exports = (gulp) ->
	require(task)(gulp, $) for task in [
		'./init-destroy'
		'./clean'
		'./build'
		'./run'
		'./deploy'
	]

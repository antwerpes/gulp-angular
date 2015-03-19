$ =
	util: require 'gulp-util'
	path: require 'path'
	template: require 'gulp-template'
	rename: require 'gulp-rename'

module.exports = (gulp, packageJson) ->
	$.packageJson = packageJson
	require(task)(gulp, $) for task in [
		'./directive'
		'./service'
		'./provider'
		'./factory'
		'./filter'
		'./controller'
	]

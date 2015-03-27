module.exports = ({gulp, $, config}) ->
	# read the config for folders that need to be copied to the parent
	# usage example in package.json:
	# "gulp-angular": {
	# 	"web": {
	#			 "bowerAssets": {
	#			 		"bootstrap": "fonts"
	#			 }
	#		}
	# }
	# will result in the bootstrap/fonts directory beeing copied to dist/fonts
	gulp.task 'web:copyBowerAssets', (cb)->
		if config.copyBowerAssets?
			streams = []
			for pkg, assetsFolder of config.copyBowerAssets
				path = $.path.join 'bower_components',pkg,assetsFolder,'**','*'
				streams.push gulp.src(path, cwd: '.').pipe gulp.dest $.path.join 'tmp', assetsFolder
			return $.mergeStream.apply(null, streams)
		else cb()



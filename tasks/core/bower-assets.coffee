module.exports = (gulp, $) ->
	# read the config for folders that need to be copied to the parent
	# usage example in package.json:
	# "gulp-angular": {
	# 	"core": {
	#			 "bowerAssets": {
	#			 		"bootstrap": "fonts"
	#			 }
	#		}
	# }
	# will result in the bootstrap/fonts directory beeing copied to dist/fonts
	gulp.task 'core:bowerAssets:copy', (cb)->
		if $.packageJson['gulp-angular']?.core?.bowerAssets?.copy
			streams = []
			for pkg, assetsFolder of $.packageJson['gulp-angular']?.core?.bowerAssets?.copy
				path = $.path.join 'bower_components',pkg,assetsFolder,'**','*'
				streams.push gulp.src(path, cwd: '.').pipe gulp.dest $.path.join 'tmp', assetsFolder
			return $.mergeStream.apply(null, streams)
		else cb()

	gulp.task 'core:bowerAssets:copy:dist', ()->
		if $.packageJson['gulp-angular']?.core?.bowerAssets?.copy
			streams = []
			for pkg, assetsFolder of $.packageJson['gulp-angular']?.core?.bowerAssets?.copy
				path = $.path.join 'src','bower_components',pkg,assetsFolder,'**','*'
				streams.push gulp.src(path, cwd: '.').pipe gulp.dest $.path.join 'dist', assetsFolder
			return $.mergeStream.apply(null, streams)



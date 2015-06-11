module.exports = ({gulp, $, config, globalConfig}) ->
	###
		Stage 1, transpile and copy everything and make a working version of the app in dev
	###

	#	copy images to dev
	gulp.task 'web:dev:copy-images', ->
		gulp.src ['src/**/*.{png,jpg,gif,svg,ico}']
			.pipe $.changed 'dev'
			.pipe gulp.dest 'dev'
			.pipe $.size()

	# copy all js, css and html files. those dont need to be touched in this phase
	gulp.task 'web:dev:copy-sources', () ->
		gulp.src ['src/**/*.{js,css,html}']
			.pipe $.changed 'dev'
			.pipe gulp.dest('dev')
			.pipe $.size()

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
	# this might be helpful for files which must be referenced from html or javascript and cannot be rebased
	gulp.task 'web:dev:copy-bower-assets', (cb)->
		if config.copyBowerAssets?
			streams = []
			for pkg, assetsFolder of config.copyBowerAssets
				path = $.path.join 'bower_components',pkg,assetsFolder,'**','*'
				streams.push gulp.src(path, cwd: '.').pipe gulp.dest $.path.join 'dev', assetsFolder
			return $.mergeStream.apply(null, streams)
		else cb()

	# copy all other assets and all bower-main-files to dev
	gulp.task 'web:dev:assets', ['web:dev:copy-bower-assets'], ->
		# copy all asset files
		ownFiles = gulp.src ['src/**/*.*', '!**/*.{js,coffee,less,scss,css,html,jade,png,jpg,gif,svg,ico}']
			.pipe $.changed 'dev'
			.pipe gulp.dest 'dev'
			.pipe $.size()

		# copy all bower-main-files
		bowerMainFiles = gulp.src $.mainBowerFiles(), base: './'
			.pipe $.changed 'dev'
			.pipe gulp.dest 'dev'
			.pipe $.size()

		return $.mergeStream ownFiles, bowerMainFiles

	# build the app to dev
	gulp.task 'web:dev:build', ['web:dev:inject', 'web:dev:assets', 'web:dev:copy-images', 'web:dev:copy-sources']

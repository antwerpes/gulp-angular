module.exports = ({gulp, $, config, globalConfig}) ->
	###
		Stage 1, transpile and copy everything and make a working version of the app in dev
	###

	#	copy images to dev
	gulp.task 'web:dev:copy-images', ->
		gulp.src ['src/**/*.{png,jpg,gif,svg,ico}', '!src/static/**']
			.pipe $.gulpChanged 'dev'
			.pipe gulp.dest 'dev'

	# copy all js, css and html files. those dont need to be touched in this phase
	gulp.task 'web:dev:copy-sources', () ->
		gulp.src ['src/**/*.{js,css,html}', '!src/index.html', '!src/static/**']
			.pipe $.gulpChanged 'dev'
			.pipe gulp.dest('dev')

	gulp.task 'web:dev:copy-static', () ->
		gulp.src ['src/static/**/*.*']
			.pipe(gulp.dest('dev/static'))

	gulp.task 'web:dev:copy-index', () ->
		gulp.src ['src/index.html']
			.pipe $.gulpChanged 'dev'
			.pipe gulp.dest('dev')

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
				path = $.path.join config.frontendDepsPath,pkg,assetsFolder,'**','*'
				streams.push gulp.src(path, cwd: '.').pipe(require('gulp-debug')()).pipe gulp.dest $.path.join 'dev', assetsFolder
			return $.mergeStream.apply(null, streams)
		else cb()

	# copy all other assets and all bower-main-files to dev
	gulp.task 'web:dev:assets', ['web:dev:copy-bower-assets'], ->
		# copy all asset files
		ownFiles = gulp.src ['src/**/*.*', '!**/*.{js,coffee,less,scss,sass,css,html,jade,png,jpg,gif,svg,ico}', '!src/static/**']
			.pipe $.gulpChanged 'dev'
			.pipe gulp.dest 'dev'

		if config.useBower
			# copy all bower-main-files
			bowerMainFiles = gulp.src $.bowerFiles(
					json: config.frontendDepsJson
					cwd: $.path.resolve('./'),
					dir: config.frontendDepsPath
				).files, base: './'
				.pipe $.gulpChanged 'dev'
				.pipe gulp.dest 'dev'

			return $.mergeStream ownFiles, bowerMainFiles
		else
			return ownFiles
	# build the app to dev
	gulp.task 'web:dev:build', ['web:dev:inject', 'web:dev:assets', 'web:dev:copy-images', 'web:dev:copy-sources', 'web:dev:copy-static']

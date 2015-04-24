module.exports = ({gulp, $, config, globalConfig}) ->

	# Optimizes images in src
	gulp.task 'web:src:optimize-images', ->
		gulp.src ['src/**/*.{png,jpg,gif,svg,ico}']
			.pipe $.imagemin
				optimizationLevel: 3
				progressive: yes
				interlaced: yes
			.pipe gulp.dest 'src'
			.pipe $.size()

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
		gulp.src ['src/**/*.{js,css,html}', '!src/index.html']
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

	###
		Stage 2: get source from dev and optimize for distribution
	###


	# Copies images from dev to dist, ignoring images found in bower components.
	gulp.task 'web:dist:copy-images', ->
		gulp.src ['dev/**/*.{png,jpg,gif,svg,ico}']
			.pipe gulp.dest 'dist'
			.pipe $.size()


	# Copies all assets from dev to dist
	gulp.task 'web:dist:assets', ->
		# copy all files other than those handled by useref and inject to dist
	 	ownFiles = gulp.src ['dev/**/*.*', '!**/*.{js,coffee,less,scss,css,html,jade,png,jpg,gif,svg,ico}', '!dev/bower_components/**']
	 		.pipe $.changed 'dist'
	 		.pipe gulp.dest 'dist'
	 		.pipe $.size()

		# copy all bower-main-files which are not js or css (i.e bootstrap fonts)
	 	bowerMainFiles = gulp.src $.mainBowerFiles(), base: './'
	 		.pipe $.ignore.exclude '**/*.{js,css}'
	 		.pipe gulp.dest 'dist'
	 		.pipe $.size()

	 	return $.mergeStream ownFiles, bowerMainFiles


	# Minifies and packages html templates/partials found in dev
	# into pre-cached angular template modules in dist.
	gulp.task 'web:dist:partials', (cb)->
		$.runSequence('web:dev:create-partials', 'web:dev:remove-html', cb)

	# create partials from html files
	gulp.task 'web:dev:create-partials', ->
		gulp.src ['dev/**/*.html', '!dev/index.html']
			.pipe $.minifyHtml
				empty: yes
				spare: yes
				quotes: yes
			.pipe $.ngHtml2js moduleName: globalConfig.angularModuleName
			.pipe $.rename suffix: '.partial'
			.pipe gulp.dest 'dev'
			.pipe $.size()

	# remove html files after creating the partial-js-files
	gulp.task 'web:dev:remove-html', (cb)->
		$.del ['dev/**/*.html', '!dev/index.html'], cb

	# rebase css urls to be relative to dev/styles/
	gulp.task 'web:dev:rebase-css', ->
		gulp.src ['dev/**/*.css'], nodir: yes, base: 'dev'
			.pipe $.cssretarget
				root: 'dev/styles'
				silent: yes
			.pipe gulp.dest 'dev'

	# inject partials,
	gulp.task 'web:dist:build', ->
		useSourcemaps = $.util.env.sourcemaps? or config.sourcemaps #TODO: DOC: --sourcemaps
		if useSourcemaps
			console.warn $.chalk.red.bgYellow 'Warning: the minified code will contain sourcemaps, the sourcecode will be visible.'
		gulp.src 'dev/index.html'
			# Inject angular pre-cached partials into index.html:
			.pipe $.inject gulp.src('dev/**/*.partial.js', read: no),
				starttag: '<!-- inject:partials -->'
				addRootSlash: no
				ignorePath: ['dev']
			# Concatenate asset files referenced in <!-- build:* -->
			# and postprocess resulting compound css and js files:
			.pipe concatenatedAssetsFilter = $.useref.assets searchPath: ['dev']
				.pipe $.if '*.css', $.minifyCss
					advanced: no # be friendly to old browsers
				.pipe $.if '*.js', $.ngAnnotate()
				.pipe $.if useSourcemaps, $.sourcemaps.init()
				.pipe $.if '*.js', $.uglify
					preserveComments: $.uglifySaveLicense
				.pipe $.if useSourcemaps, $.sourcemaps.write()
				# Append a revision hash to the filename:
				.pipe $.rev()
			.pipe concatenatedAssetsFilter.restore()
			# Continue working on index.html and compound css and js files.
			.pipe $.useref() # replace <!-- build:* --> placeholders with paths of compound files
			.pipe $.revReplace() # add revision hashes to compound file references
			.pipe htmlFilter = $.filter 'index.html'
				.pipe $.minifyHtml
					empty: yes
					spare: yes
					quotes: yes
			.pipe htmlFilter.restore()
			# Write out compound files and changes to index.html
			.pipe gulp.dest 'dist'
			.pipe $.size()

	# Builds a production-/distribution-ready version of the web app into the dist directory.
	gulp.task 'web:build', ['web:clean'], (cb) ->
		$.runSequence 'web:dev:build',
			'web:dist:copy-images'
			'web:dist:assets',
			'web:dev:rebase-css',
			'web:dist:partials',
			'web:dist:build',
			'web:dev:clean',
			cb

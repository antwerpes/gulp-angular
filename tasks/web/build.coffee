module.exports = ({gulp, $, config, globalConfig}) ->
	
	# Optimizes images in src
	gulp.task 'web:optimize:images', ->
		gulp.src ['src/**/*.{png,jpg,gif,svg,ico}']
			.pipe $.imagemin
				optimizationLevel: 3
				progressive: yes
				interlaced: yes
			.pipe gulp.dest 'src'
			.pipe $.size()

	###
		Stage 1, transpile and copy everything and make a working version of the app in tmp
	###

	#	copy images to tmp
	gulp.task 'web:build:images:dev', ->
		gulp.src ['src/**/*.{png,jpg,gif,svg,ico}']
			.pipe $.changed 'tmp'
			.pipe gulp.dest 'tmp'
			.pipe $.size()

	# copy all js, css and html files. those dont need to be touched in this phase
	gulp.task 'web:build:copy-sources', () ->
		gulp.src ['src/**/*.{js,css,html}', '!src/index.html']
			.pipe $.changed 'tmp'
			.pipe gulp.dest('tmp')
			.pipe $.size()

	# copy all other assets and all bower-main-files to tmp
	gulp.task 'web:build:assets:dev', ['web:copyBowerAssets'], ->
		# copy all asset files
		ownFiles = gulp.src ['src/**/*.*', '!**/*.{js,coffee,less,scss,css,html,jade,png,jpg,gif,svg,ico}']
			.pipe $.changed 'tmp'
			.pipe gulp.dest 'tmp'
			.pipe $.size()

		# copy all bower-main-files
		bowerMainFiles = gulp.src $.mainBowerFiles(), base: './'
			.pipe $.changed 'tmp'
			.pipe gulp.dest 'tmp'
			.pipe $.size()

		return $.mergeStream ownFiles, bowerMainFiles

	# build the app to tmp
	gulp.task 'web:build:dev', ['web:inject', 'web:build:assets:dev', 'web:build:images:dev', 'web:build:copy-sources']

	###
		Stage 2: get source from tmp and optimize for distribution
	###


	# Copies images from tmp to dist, ignoring images found in bower components.
	gulp.task 'web:build:copy-images', ->
		gulp.src ['tmp/**/*.{png,jpg,gif,svg,ico}']
			.pipe gulp.dest 'dist'
			.pipe $.size()


	# Copies all assets from tmp to dist
	gulp.task 'web:build:assets', ->
		# copy all files other than those handled by useref and inject to dist
	 	ownFiles = gulp.src ['tmp/**/*.*', '!**/*.{js,coffee,less,scss,css,html,jade,png,jpg,gif,svg,ico}', '!tmp/bower_components/**']
	 		.pipe $.changed 'dist'
	 		.pipe gulp.dest 'dist'
	 		.pipe $.size()

		# copy all bower-main-files which are not js or css (i.e bootstrap fonts)
	 	bowerMainFiles = gulp.src $.mainBowerFiles(), base: './'
	 		.pipe $.ignore.exclude '**/*.{js,css}'
	 		.pipe gulp.dest 'dist'
	 		.pipe $.size()

	 	return $.mergeStream ownFiles, bowerMainFiles


	# Minifies and packages html templates/partials found in tmp
	# into pre-cached angular template modules in dist.
	gulp.task 'web:build:partials', (cb)->
		$.runSequence('web:build:create-partials', 'web:build:remove-html', cb)

	# create partials from html files
	gulp.task 'web:build:create-partials', ->
		gulp.src ['tmp/**/*.html', '!tmp/index.html']
			.pipe $.minifyHtml
				empty: yes
				spare: yes
				quotes: yes
			.pipe $.ngHtml2js moduleName: globalConfig.angularModuleName
			.pipe $.rename suffix: '.partial'
			.pipe gulp.dest 'tmp'
			.pipe $.size()

	# remove html files after creating the partial-js-files
	gulp.task 'web:build:remove-html', (cb)->
		$.del ['tmp/**/*.html', '!tmp/index.html'], cb

	# rebase css urls to be relative to tmp/styles/
	gulp.task 'web:build:rebase-css', ->
		gulp.src ['tmp/**/*.css'], nodir: yes, base: 'tmp'
			.pipe $.cssretarget
				root: 'tmp/styles'
			.pipe gulp.dest 'tmp'

	# inject partials,
	gulp.task 'web:build:dist', ->
		useSourcemaps = $.util.env.sourcemaps? or config.sourcemaps #TODO: DOC: --sourcemaps
		if useSourcemaps
			console.warn $.chalk.red.bgYellow 'Warning: the minified code will contain sourcemaps, the sourcecode will be visible.'
		gulp.src 'tmp/index.html'
			# Inject angular pre-cached partials into index.html:
			.pipe $.inject gulp.src('tmp/**/*.partial.js', read: no),
				starttag: '<!-- inject:partials -->'
				addRootSlash: no
				ignorePath: ['tmp']
			# Concatenate asset files referenced in <!-- build:* -->
			# and postprocess resulting compound css and js files:
			.pipe concatenatedAssetsFilter = $.useref.assets searchPath: ['tmp']
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
		$.runSequence 'web:build:dev',
			'web:build:copy-images'
			'web:build:assets',
			'web:build:rebase-css',
			'web:build:partials',
			'web:build:dist',
			'web:clean:tmp',
			cb

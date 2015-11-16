module.exports = ({gulp, $, config, globalConfig}) ->
	###
		Stage 2: get source from dev and optimize for distribution
	###

	# Copies images from dev to dist, ignoring images found in bower components.
	gulp.task 'web:dist:copy-images', ->
		gulp.src ['dev/**/*.{png,jpg,gif,svg,ico}', '!dev/static/**/*']
			.pipe gulp.dest 'dist'
			.pipe $.size()

	gulp.task 'web:dist:copy-static', () ->
		gulp.src ['dev/static/**/*.*']
			.pipe(gulp.dest('dist/static'))


	# Copies all assets from dev to dist
	gulp.task 'web:dist:assets', ->
		# copy all files other than those handled by useref and inject to dist
	 	ownFiles = gulp.src ['dev/**/*.*', '!**/*.{js,coffee,less,scss,sass,css,html,jade,png,jpg,gif,svg,ico}', '!dev/bower_components/**', '!dev/static/**/*']
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
		gulp.src ['dev/**/*.html', '!dev/index.html', '!dev/static/**/*']
			.pipe $.minifyHtml
				empty: yes
				spare: yes
				quotes: yes
			.pipe $.ngHtml2js moduleName: globalConfig.angularModuleName
			.pipe $.rename suffix: '.partial'
			.pipe gulp.dest 'dev'
			.pipe $.size()

	# remove html files after creating the partial-js-files
	gulp.task 'web:dev:remove-html', ()->
		$.del ['dev/**/*.html', '!dev/index.html', '!dev/static/**/*']

	# rebase css urls to be relative to dev/styles/
	gulp.task 'web:dev:rebase-css', ->
		gulp.src ['dev/**/*.css', '!dev/static/**/*'], nodir: yes, base: 'dev'
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
			.pipe $.inject gulp.src(['dev/**/*.partial.js', '!dev/static/**/*'], read: no),
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
			.pipe htmlFilter = $.filter('index.html', restore: yes)
				.pipe $.minifyHtml
					empty: yes
					spare: yes
					quotes: yes
			.pipe htmlFilter.restore
			# Write out compound files and changes to index.html
			.pipe gulp.dest 'dist'
			.pipe $.size()

	# Builds a production-/distribution-ready version of the web app into the dist directory.
	gulp.task 'web:build', ['web:clean'], (cb) ->
		$.runSequence 'web:dev:build',
			'web:dist:copy-images'
			'web:dist:copy-static'
			'web:dist:assets',
			'web:dev:rebase-css',
			'web:dist:partials',
			'web:dist:build',
			'web:dev:clean',
			cb

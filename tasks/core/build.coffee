module.exports = (gulp, $) ->

	###
		Stage 1, Build everything and make a functional Version of the app in tmp
	###

	gulp.task 'core:build:images:dev', ->
		gulp.src ['src/**/*.{png,jpg,gif,svg,ico}']
			.pipe $.changed 'tmp'
			.pipe gulp.dest 'tmp'
			.pipe $.size()

	gulp.task 'core:build:copy-sources:dev', () ->
		gulp.src ['src/**/*.{js,css,html}', '!src/index.html']
			.pipe gulp.dest('tmp')

	gulp.task 'core:build:assets:dev', ['core:bowerAssets:copy'], ->
		# copy all files other than those handled by useref and inject to dist
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

	gulp.task 'core:build:dev', ['core:inject', 'core:build:assets:dev', 'core:build:images:dev', 'core:build:copy-sources:dev']

	###
		Stage 2, get source from tmp and optimize for distribution
	###

	# Optimizes and copies images from tmp to dist, ignoring images found in bower components.
	gulp.task 'core:build:images', ->
		gulp.src ['tmp/**/*.{png,jpg,gif,svg,ico}',  '!tmp/bower_components/**/*']
			.pipe $.changed 'dist'
			.pipe $.imagemin
				optimizationLevel: 3
				progressive: yes
				interlaced: yes
			.pipe gulp.dest 'dist'
			.pipe $.size()

	# Copies all assets from tmp to dist
	gulp.task 'core:build:assets', ->
		 	# copy all files other than those handled by useref and inject to dist
	 	ownFiles = gulp.src ['tmp/**/*.*', '!**/*.{js,coffee,less,scss,css,html,jade,png,jpg,gif,svg,ico}', '!tmp/bower_components/**']
	 		.pipe $.changed 'dist'
	 		.pipe gulp.dest 'dist'
	 		.pipe $.size()

		# copy all bower-main-files which are not js or css (i.e bootstrap fonts)
	 	bowerMainFiles = gulp.src $.mainBowerFiles(), base: 'src'
	 		.pipe $.ignore.exclude '**/*.{js,css}'
	 		.pipe gulp.dest 'dist'
	 		.pipe $.size()

	 	return $.mergeStream ownFiles, bowerMainFiles


	# Minifies and packages html templates/partials found in src
	# into pre-cached angular template modules in dist.
	gulp.task 'core:build:partials', (cb)->
		$.runSequence('core:build:create-partials', 'core:build:remove-html', cb)

	gulp.task 'core:build:create-partials', ->
		gulp.src ['tmp/**/*.html', '!tmp/index.html']
			.pipe $.minifyHtml
				empty: yes
				spare: yes
				quotes: yes
			.pipe $.ngHtml2js moduleName: $.packageJson.name
			.pipe $.rename suffix: '.partial'
			.pipe gulp.dest 'tmp'
			.pipe $.size()

	gulp.task 'core:build:remove-html', (cb)->
		$.del ['tmp/**/*.html', '!tmp/index.html'], cb


	# When building a production-/distribution-ready version of the
	# web app, all html, css and js files being present
	# in src and tmp need further processing. This pre-
	# build task ensures that from now on, changes are
	# being made on copies of the original files so that
	# building dist has no side effect on files that are
	# already present in src or have been generated into
	# tmp for development purposes (e.g. we don't want
	# partials to be injected into tmp/index.html, which
	# would mess up core:serve:dev). The task does three things:
	# 1. Copies index.html from tmp to dist
	# 2. Copies those css files that are referenced in
	#    tmp/index.html (within <!--  build:css --> blocks)
	#    to dist while rebasing all urls found in their
	# 	 css rules. Rebasing takes place with respect to
	#    the location of the final, concatenated css files
	#    that are yet to be generated in the following core:build task
	# 3. Copies those js files that are referenced in
	#    tmp/index.html (within <!-- build:js --> blocks)
	#    to dist, leaving their content untouched.
	# TODO: check how absolute paths are being rebased
	gulp.task 'core:build:dist', ['core:build:partials'], ->
		# Define reusable partial pipelines with lazypipe so
		# that more than one operation can be performed in a $.if step.
		# rebaseTmp and rebaseSrc lazypipes receive the stream of individual asset
		# files filtered by $.if and process those files separately from
		# the task's main stream and so that they can be written out independently.
		# copyToDist = $.lazypipe()
		# 	.pipe $.copy, 'dist', prefix: 1 # strips away the fist path component
		# 	.pipe gulp.dest, 'dist'
		rebaseTmp = $.lazypipe()
			.pipe $.cssretarget, root: 'tmp/styles' # later: dist/styles, but here tmp to not confuse the plugin
			.pipe () -> return gulp.dest 'tmp'

		gulp.src 'tmp/index.html'
			# Read and pass asset references within <!-- build:* -->
			# blocks into the stream for further processing.
			# Search paths are not defined in html because they are not
			# the same across all build steps (see build:dist task):
			.pipe individualAssetsFilter = $.useref.assets
					noconcat: yes
					searchPath: ['tmp']
				# Process files in tmp and src differently (different roots):
				.pipe $.if /tmp.*\.css$/, rebaseTmp()
				# .pipe $.if /.*\.js$/, copyToDist()
			.pipe individualAssetsFilter.restore()
			# Bring index.html back into the stream.
			# Previous asset source files will keep staying around in the
			# stream so ignore them to prevent writing them back!
			# Write out index.html only:
			.pipe $.filter 'index.html'
			# Inject angular pre-cached partials into index.html:
			.pipe $.inject gulp.src('tmp/**/*.partial.js', read: no),
				starttag: '<!-- inject:partials -->'
				addRootSlash: no
				ignorePath: ['tmp'] # strips away the 'dist/' path component
			# Concatenate asset files referenced in <!-- build:* -->
			# and postprocess resulting compound css and js files:
			.pipe concatenatedAssetsFilter = $.useref.assets searchPath: ['tmp']
				.pipe $.if '*.css', $.minifyCss
					advanced: no # be friendly to old browsers
				.pipe $.if '*.js', $.ngAnnotate()
				.pipe $.if '*.js', $.uglify
					preserveComments: $.uglifySaveLicense
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
	gulp.task 'core:build', ['core:clean'], (cb)->
		$.runSequence 'core:build:dev', 'core:build:images', 'core:build:assets', 'core:build:dist', cb

	gulp.task 'core:build:dirty', ['core:inject', 'core:build:images', 'core:build:assets', 'core:build:partials'], (cb) ->
		$.runSequence 'core:build-build', 'core:build-cleanup', cb


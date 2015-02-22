module.exports = (gulp, $) ->
	# Optimizes and copies images from src to dist, ignoring images found in bower components.
	gulp.task 'core:build:images', ->
		gulp.src ['src/**/*.{png,jpg,gif,svg,ico}', '!src/bower_components/**']
			.pipe $.imagemin
				optimizationLevel: 3
				progressive: yes
				interlaced: yes
			.pipe gulp.dest 'dist'
			.pipe $.size()

	# Copies fonts from src to dist, including those found in bower components.
	gulp.task 'core:build:fonts', ->
		bowerFonts = gulp.src $.mainBowerFiles(), base: 'src'
			.pipe $.filter '**/*.{otf,eot,svg,ttf,woff}'
		myFonts = gulp.src ['src/**/*.{otf,eot,svg,ttf,woff}', '!src/bower_components/**']
		$.merge bowerFonts, myFonts
			.pipe gulp.dest 'dist'
			.pipe $.size()

	# Minifies and packages html templates/partials found in src
	# into pre-cached angular template modules in dist.
	gulp.task 'core:build:partials', ->
		gulp.src ['src/**/*.html', '!src/index.html', '!src/bower_components/**']
			.pipe $.minifyHtml
				empty: yes
				spare: yes
				quotes: yes
			.pipe $.ngHtml2js moduleName: $.packageJson.name
			.pipe $.rename suffix: '.partial'
			.pipe gulp.dest 'dist'
			.pipe $.size()

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
	gulp.task 'core:build-prepare', ->
		# Define reusable partial pipelines with lazypipe so
		# that more than one operation can be performed in a $.if step.
		# rebaseTmp and rebaseSrc lazypipes receive the stream of individual asset
		# files filtered by $.if and process those files separately from
		# the task's main stream and so that they can be written out independently.
		copyToDist = $.lazypipe()
			.pipe $.copy, 'dist', prefix: 1 # strips away the fist path component
			.pipe gulp.dest, 'dist'
		rebaseTmp = $.lazypipe()
			.pipe $.cssretarget, root: 'tmp/styles' # later: dist/styles, but here tmp to not confuse the plugin
			.pipe copyToDist
		rebaseSrc = $.lazypipe()
			.pipe $.cssretarget, root: 'src/styles' # later: dist/styles, but here src to not confuse the plugin
			.pipe copyToDist
		gulp.src 'tmp/index.html'
			# Read and pass asset references within <!-- build:* -->
			# blocks into the stream for further processing.
			# Search paths are not defined in html because they are not
			# the same across all build steps (see build:dist task):
			.pipe individualAssetsFilter = $.useref.assets
					noconcat: yes
					searchPath: ['tmp', 'src']
				# Process files in tmp and src differently (different roots):
				.pipe $.if /tmp.*css/, rebaseTmp()
				.pipe $.if /src.*css/, rebaseSrc()
				.pipe $.if '*.js', copyToDist()
			.pipe individualAssetsFilter.restore()
			# Bring index.html back into the stream.
			# Previous asset source files will keep staying around in the
			# stream so ignore them to prevent writing them back!
			# Write out index.html only:
			.pipe $.filter 'index.html'
			.pipe gulp.dest 'dist'

	# Performs the actual minification and concatenation of html, css and js files,
	# resulting in a production-/distribution-ready version of the web app in dist.
	gulp.task 'core:build-build', ['core:build-prepare'], ->
		gulp.src 'dist/index.html'
			# Inject angular pre-cached partials into index.html:
			.pipe $.inject gulp.src('dist/**/*.partial.js', read: no),
				starttag: '<!-- inject:partials -->'
				addRootSlash: no
				ignorePath: ['dist'] # strips away the 'dist/' path component
			# Concatenate asset files referenced in <!-- build:* -->
			# and postprocess resulting compound css and js files:
			.pipe concatenatedAssetsFilter = $.useref.assets searchPath: ['dist']
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

	# Deletes those css and js files from dist that were generated by the core:build-prepare
	# task and leaves the dist directory in a clean state without any remaining empty directories.
	gulp.task 'core:build-cleanup', (cb) ->
		$.del ['dist/**/*.{css,js}', '!dist/{styles,scripts}/**'], ->
			deleteEmptyDirectories = (dir) ->
				for item in $.fs.readdirSync dir
					filename = $.path.join dir, item
					if $.fs.statSync(filename).isDirectory() then deleteEmptyDirectories filename
				try $.fs.rmdirSync dir catch # suppress ENOTEMPTY exception
			deleteEmptyDirectories 'dist'
			cb()

	# Builds a production-/distribution-ready version of the web app into the dist directory.
	gulp.task 'core:build', (cb) ->
		$.runSequence 'core:clean', ['core:inject', 'core:build:images', 'core:build:fonts', 'core:build:partials'], 'core:build-build', 'core:build-cleanup', cb

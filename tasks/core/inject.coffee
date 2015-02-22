module.exports = (gulp, $) ->
	# Injects file references of css and js files found in src and tmp into tmp/index.html.
	# Copies src/index.html over to tmp while injecting references
	# of css and js source files found in src and tmp into
	# <!-- inject:* --> blocks.
	# Because we want to overwrite bootstrap styles in vendor.css,
	# we @import them over there and don't inject them here.
	gulp.task 'core:inject', ['core:transpile'], ->
		gulp.src 'src/index.html'
			.pipe $.wiredep.stream
				directory: 'src/bower_components'
				exclude: 'bootstrap/*.css'
			.pipe $.inject gulp.src(['{src,tmp}/**/*.css', '!src/bower_components/**'], read: no),
				starttag: '<!-- inject:styles -->'
				addRootSlash: no
				ignorePath: ['src', 'tmp'] # strips away the 'str/' and 'tmp/' path components
			.pipe $.inject gulp.src(['{src,tmp}/**/*.js', '!src/bower_components/**', '!**/*{test,e2e,partial}.js'], read: no),
				starttag: '<!-- inject:scripts -->'
				addRootSlash: no
				ignorePath: ['src', 'tmp']
			.pipe gulp.dest 'tmp'
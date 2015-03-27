module.exports = ({gulp, $, config}) ->
	# Injects file references of css and js files found in src and tmp into tmp/index.html.
	# Copies src/index.html over to tmp while injecting references
	# of css and js source files found in src and tmp into
	# <!-- inject:* --> blocks.
	# Because we want to overwrite bootstrap styles in vendor.css,
	# we @import them over there and don't inject them here.
	gulp.task 'core:inject', ['core:transpile'], ->
		# sort js dependencies by modules and dependecies
		jsSources = gulp.src(['tmp/**/*.js', '!**/*{test,e2e,partial}.js', '!tmp/bower_components/**/*' ], nodir:yes)
			.pipe($.angularFilesort())

		cssSources = gulp.src(['tmp/**/*.css', '!tmp/bower_components/**/*'], read: no, nodir: yes)

		gulp.src 'src/index.html'
			.pipe $.wiredep.stream
				ignorePath: /\.\.\//
			.pipe $.inject cssSources,
				starttag: '<!-- inject:styles -->'
				addRootSlash: no
				ignorePath: ['tmp'] # strips away the 'src/' and 'tmp/' path components
			.pipe $.inject jsSources,
				starttag: '<!-- inject:scripts -->'
				addRootSlash: no
				ignorePath: ['src', 'tmp']
			.pipe gulp.dest 'tmp'

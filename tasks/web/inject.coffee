module.exports = ({gulp, $, config}) ->
	# Injects file references of css and js files found in src and dev into dev/index.html.
	# Copies src/index.html over to dev while injecting references
	# of css and js source files found in src and dev into
	# <!-- inject:* --> blocks.
	# Because we want to overwrite bootstrap styles in vendor.css,
	# we @import them over there and don't inject them here.
	gulp.task 'web:dev:inject', ['web:dev:transpile'], ->
		# sort js dependencies by modules and dependecies
		jsSources = gulp.src(['dev/**/*.js', '!**/*{test,e2e,partial}.js', '!dev/bower_components/**/*' ], nodir:yes)
			.pipe($.angularFilesort())

		cssSources = gulp.src(['dev/**/*.css', '!dev/bower_components/**/*'], read: no, nodir: yes)

		gulp.src 'src/index.html'
			.pipe $.wiredep.stream
				ignorePath: /\.\.\//
			.pipe $.inject cssSources,
				starttag: '<!-- inject:styles -->'
				addRootSlash: no
				ignorePath: ['dev'] # strips away the 'src/' and 'dev/' path components
			.pipe $.inject jsSources,
				starttag: '<!-- inject:scripts -->'
				addRootSlash: no
				ignorePath: ['src', 'dev']
			.pipe gulp.dest 'dev'

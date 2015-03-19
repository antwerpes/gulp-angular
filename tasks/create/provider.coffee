module.exports = (gulp, $) ->
	gulp.task 'create:provider', ->
		if not $.util.env.n or $.util.env.n is ''
			$.util.log $.util.colors.red('Please give a name with -n')
			process.exit 1
		name = $.util.env.n
		if 'here' of $.util.env
			console.log "creating provider '#{$.util.env.n}' at '#{process.env.INIT_CWD}'"
			destPath = $.path.join process.env.INIT_CWD, name
		else
			destPath = './src/services/' + name + '/'

		cameledName = name.replace(/-([a-z])/g, (g) ->
			g[1].toUpperCase()
		)

		gulp.src($.path.join(__dirname, 'templates/provider/template.provider.coffee'))
		.pipe($.template(
			appName: $.packageJson.name
			cameledName: cameledName
		))
		.pipe($.rename(name + '.provider.coffee'))
		.pipe gulp.dest(destPath)
		return

module.exports = ({gulp, $, config, globalConfig}) ->
	gulp.task 'create:filter', ->
		if not $.util.env.n or $.util.env.n is ''
			$.util.log $.util.colors.red('Please give a name with -n')
			process.exit 1
		name = $.util.env.n
		if 'here' of $.util.env
			console.log "creating filter '#{$.util.env.n}' at '#{process.env.INIT_CWD}'"
			destPath = $.path.join process.env.INIT_CWD, name
		else
			destPath = './src/services/' + name + '/'
		cameledName = name.replace(/-([a-z])/g, (g) ->
			g[1].toUpperCase()
		)

		gulp.src($.path.join(__dirname, '../../templates/filter/template.filter.coffee'))
		.pipe($.template(
			appName: globalConfig.angularModuleName
			cameledName: cameledName
		))
		.pipe($.rename(name + '.filter.coffee'))
		.pipe gulp.dest(destPath)
		return

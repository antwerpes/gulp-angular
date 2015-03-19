module.exports = (gulp, $) ->
	gulp.task 'create:directive', ->
		if not $.util.env.n or $.util.env.n is ''
			$.util.log $.util.colors.red('Please give a name with -n')
			process.exit 1
		name = $.util.env.n
		if 'here' of $.util.env
			console.log "creating directive '#{$.util.env.n}' at '#{process.env.INIT_CWD}'"
			destPath = $.path.join process.env.INIT_CWD, name
			path = $.path.relative($.path.join($.path.resolve(process.cwd()), 'src'), process.env.INIT_CWD)
		else
			destPath = './src/components/' + name + '/'
			path = 'components'

		cameledName = name.replace(/-([a-z])/g, (g) ->
			g[1].toUpperCase()
		)

		gulp.src($.path.join(__dirname, '../../templates/directive/template.directive.coffee'))
		.pipe($.template(
			appName: $.packageJson.name
			name: name
			cameledName: cameledName
			path: path
		))
		.pipe($.rename(name + '.directive.coffee'))
		.pipe gulp.dest(destPath)

		if 'jade' of $.util.env
			gulp.src($.path.join(__dirname, '../../templates/directive/template.jade'))
			.pipe($.template(name: name))
			.pipe($.rename(name + '.jade'))
			.pipe gulp.dest(destPath)
		else
			gulp.src($.path.join(__dirname, '../../templates/directive/template.html'))
			.pipe($.template(name: name))
			.pipe($.rename(name + '.html'))
			.pipe gulp.dest(destPath)
		gulp.src($.path.join(__dirname, '../../templates/directive/template.less'))
		.pipe($.rename(name + '.less'))
		.pipe gulp.dest(destPath)
		return

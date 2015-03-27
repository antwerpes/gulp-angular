module.exports = ({gulp, $, config, globalConfig}) ->
	gulp.task 'create:controller', ->
		if not $.util.env.n or $.util.env.n is ''
			$.util.log $.util.colors.red('Please give a name with -n')
			process.exit 1
		name = $.util.env.n
		if 'here' of $.util.env
			console.log "creating controller '#{$.util.env.n}' at '#{process.env.INIT_CWD}'"
			destPath = $.path.join process.env.INIT_CWD, name
		else
			destPath = './src/app/' + name + '/'
		cameledName = name.replace(/-([a-z])/g, (g) ->
			g[1].toUpperCase()
		)
		cameledName = cameledName.charAt(0).toUpperCase() + cameledName.slice(1)

		gulp.src($.path.join(__dirname, '../../templates/controller/template.controller.coffee'))
		.pipe($.template(
			appName: globalConfig.angularModuleName
			name: cameledName + 'Controller'
		))
		.pipe($.rename(name + '.controller.coffee'))
		.pipe gulp.dest(destPath)

		if ('jade' of $.util.env) or config.jade
			gulp.src($.path.join(__dirname, '../../templates/controller/template.jade'))
			.pipe($.template(name: cameledName + 'Controller'))
			.pipe($.rename(name + '.jade'))
			.pipe gulp.dest(destPath)
		else
			gulp.src($.path.join(__dirname, '../../templates/controller/template.html'))
			.pipe($.template(name: cameledName + 'Controller'))
			.pipe($.rename(name + '.html'))
			.pipe gulp.dest(destPath)

		gulp.src($.path.join(__dirname, '../../templates/controller/template.less'))
		.pipe($.rename(name + '.less'))
		.pipe gulp.dest(destPath)

		gulp.src($.path.join(__dirname, '../../templates/controller/template.e2e.coffee'))
		.pipe($.template(name: cameledName))
		.pipe($.rename(name + '.e2e.coffee'))
		.pipe gulp.dest(destPath)

		gulp.src($.path.join(__dirname, '../../templates/controller/template.test.coffee'))
		.pipe($.template(appName: globalConfig.angularModuleName))
		.pipe($.rename(name + '.test.coffee'))
		.pipe gulp.dest(destPath)
		return

module.exports = ({gulp, $, config, globalConfig}) ->
	gulp.task 'create:project', ->
		gulp.src($.path.join(__dirname, '../../templates/project/**/*'))
		.pipe($.template(
			moduleName: globalConfig.angularModuleName
		))
		.pipe gulp.dest('./')

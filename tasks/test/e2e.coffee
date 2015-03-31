module.exports = ({gulp, $, config}) ->

	gulp.task 'webdriver_update', $.protractor.webdriver_update

	gulp.task 'e2e', ['webdriver_update', 'web:serve:dev'], ->
		gulp.src '{src,tmp}/**/*.e2e.js}'
			.pipe $.protractor.protractor
				configFile: 'test/protractor.conf.js'
			.on 'error', (e) ->
				console.log(e)
			.on 'end', () ->
				console.log('end')
	return

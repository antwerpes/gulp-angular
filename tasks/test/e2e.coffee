module.exports = ({gulp, $, config}) ->

	gulp.task 'webdriver_update', $.protractor.webdriver_update

	gulp.task 'test:e2e:whatever', ['webdriver_update'], -> # connects to whatever is currently being served
		gulp.src '{src,tmp}/**/*.e2e.js}'
			.pipe $.protractor.protractor
				configFile: 'protractor.conf.js'
			.on 'error', -> process.exit()
			.on 'end', -> process.exit()

	gulp.task 'test:e2e:dev', ['web:serve:dev'], -> gulp.start 'test:e2e:whatever'
	gulp.task 'test:e2e:dist', ['web:serve:dist'], -> gulp.start 'test:e2e:whatever'


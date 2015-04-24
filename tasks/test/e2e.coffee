module.exports = ({gulp, $, config}) ->

	gulp.task 'test:protractor:webdriver-update', $.protractor.webdriver_update

	gulp.task 'test:protractor', ['test:protractor:webdriver-update'], -> # connects to whatever is currently being served
		gulp.src '{src,dev}/**/*.e2e.js}'
			.pipe $.protractor.protractor
				configFile: 'protractor.conf.js'
			.on 'error', -> process.exit()
			.on 'end', -> process.exit()

	gulp.task 'test:dev:e2e', ['web:dev:serve'], -> gulp.start 'test:protractor'
	gulp.task 'test:dist:e2e', ['web:dist:serve'], -> gulp.start 'test:protractor'


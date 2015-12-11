module.exports = ({gulp, $, config, globalConfig}) ->

	# Optimizes images in src
	gulp.task 'web:dist:optimize-images', ->
		gulp.src ['dist/**/*.{png,jpg,gif,svg,ico}']
			.pipe $.imagemin
				optimizationLevel: 3
				progressive: yes
				interlaced: yes
			.pipe gulp.dest 'dist'
			.pipe $.size()

	gulp.task 'web:src:optimize-images', ->
		console.warn 'This task will replace all your Images in \'src\' with optimized ones.'
		gulp.src ['src/**/*.{png,jpg,gif,svg,ico}']
			.pipe $.imagemin
				optimizationLevel: 3
				progressive: yes
				interlaced: yes
			.pipe gulp.dest 'src'
			.pipe $.size()

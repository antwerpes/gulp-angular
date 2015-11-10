module.exports = ({gulp, $, config, globalConfig}) ->

	# Optimizes images in src
	gulp.task 'web:src:optimize-images', ->
		gulp.src ['dist/**/*.{png,jpg,gif,svg,ico}']
			.pipe $.imagemin
				optimizationLevel: 3
				progressive: yes
				interlaced: yes
			.pipe gulp.dest 'dist'
			.pipe $.size()

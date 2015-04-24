module.exports = ({gulp, $, config}) ->
	# Watches bower.json and triggers inject when its content changes.
	# Watches less, sass and coffeescript files in src (not bower components)
	# and triggers retranspilation when their content changes. New files are
	# being transpiled and injected into dev/index.html.
	# Counterparts in dev of files being deleted from src are also being deleted
	# with inject being triggered afterwards.
	gulp.task 'nwjs:watch', ->
		$.runSequence 'web:dev:serve', 'nwjs:build:dev'



module.exports = (gulp) ->
	require(task)(gulp) for task in [
		'./tasks/core'
	]

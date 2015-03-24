module.exports = (gulp, packageJson, $) ->
	$.packageJson = packageJson
	require(task)(gulp, $) for task in [
		'./directive'
		'./service'
		'./provider'
		'./factory'
		'./filter'
		'./controller'
	]

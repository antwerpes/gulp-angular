module.exports = (gulp, packageJson, $) ->
	$.packageJson = packageJson
	require(task)(gulp, $) for task in [
		'./init-destroy'
		'./clean'
		'./build'
		'./run'
		'./deploy'
	]

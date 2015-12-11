module.exports = ({gulp, $, config}) ->
	# Deletes dev and empties the dist directory leaving the directory itself
	# intact so that symlinks pointing to it (e.g. cordova www) don't break.
	gulp.task 'web:dist:clean', () -> $.del ['dist/*']
	gulp.task 'web:dev:clean', () -> $.del ['dev/*']
	gulp.task 'web:clean', ['web:dist:clean', 'web:dev:clean']
	gulp.task 'exterminate', ->

		console.log("      _n____n__");
		console.log("     /         \\---||--<");
		console.log("    /___________\\");
		console.log("    _|____|____|_");
		console.log("    _|____|____|_");
		console.log("     |    |    |");
		console.log("    --------------");
		console.log("    | || || || ||\\");
		console.log("    | || || || || \\++++++++------<");
		console.log("    ===============");
		console.log("    |   |  |  |   |");
		console.log("   (| O | O| O| O |)");
		console.log("   |   |   |   |   |");
		console.log("  (| O | O | O | O |)");
		console.log("   |   |   |   |    |");
		console.log(" (| O |  O | O  | O |)");
		console.log("  |   |    |    |    |");
		console.log(" (| O |  O |  O |  O |)");
		console.log(" ======================");
		return $.runSequence 'web:clean'


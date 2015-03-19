angular.module('<%= appName %>')
	.factory '<%= cameledName %>', ->
		# Service logic
		# ...

		answerToEverything = 42

		# Public API here
		{
			someMethod: ->
				answerToEverything
		}

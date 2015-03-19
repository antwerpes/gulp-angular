angular.module('<%= appName %>')
.directive '<%= cameledName %>', () ->
	scope: {}
	templateUrl: '<%= path %>/<%= name %>/<%= name %>.html'
	restrict: 'E'
	link: ($scope, element, attribs) ->
		#directive code here

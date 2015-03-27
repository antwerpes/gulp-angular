angular.module('<%= moduleName %>', [
	'ui.router'
]).config ($stateProvider, $urlRouterProvider) ->
	$stateProvider.state 'welcome',
		url: '/'
		templateUrl: 'app/welcome/welcome.html'

	$urlRouterProvider.otherwise ($injector) ->
		$state = $injector.get '$state'
		$state.go 'welcome'

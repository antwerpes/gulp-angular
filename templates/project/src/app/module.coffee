angular.module('<%= moduleName %>', [
	'ui.router'
]).config ($stateProvider, $urlRouterProvider, $compileProvider) ->
	$compileProvider.debugInfoEnabled no
	#console.error 'DISABLE DEBUG INFO BEFORE RELEASE'
	$stateProvider.state 'welcome',
		url: '/'
		templateUrl: 'app/welcome/welcome.html'

	$urlRouterProvider.otherwise ($injector) ->
		$state = $injector.get '$state'
		$state.go 'welcome'

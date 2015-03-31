describe 'controllers', ->
	scope = undefined
	beforeEach module('<%= moduleName %>')
	beforeEach inject(($rootScope) ->
		scope = $rootScope.$new()
		return
	)

	#place your tests here

	return

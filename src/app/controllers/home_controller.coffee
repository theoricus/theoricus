class HomeController extends app.controllers.AppController
	index:( data, fn )->
		@render "headline", new app.models.HomeModel, fn
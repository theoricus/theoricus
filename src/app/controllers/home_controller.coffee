class HomeController extends app.controllers.AppController
	index:( data )->
		@render "headline", new app.models.HomeModel
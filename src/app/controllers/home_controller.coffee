class HomeController extends app.controllers.AppController
	home:( data )->
		@render "home", new app.models.HomeModel
	
	features:( data ) ->
		@render "features", ["Feature A", "Feature B"]
	
	show_feature:( id ) ->
		@render "feature", id
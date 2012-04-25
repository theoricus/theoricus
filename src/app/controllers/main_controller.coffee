class MainController extends app.controllers.AppController
	index:()->
		# render the 'main' view
		# @usage: @render view_name, data
		@render "main", new app.models.MainModel
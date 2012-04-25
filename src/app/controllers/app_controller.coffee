class AppController extends theoricus.mvc.Controller
	index:->
		@model = new app.models.AppModel
		@render "app", @model
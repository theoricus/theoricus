class HomeController extends app.controllers.AppController
	
	index:()->
		console.log "HomeController.index()"

	features:()->
		console.log "HomeController.features()"

	show_feature:( id, genre = "pop" )->
		console.log "HomeController.show_feature( #{id}, #{genre} )"
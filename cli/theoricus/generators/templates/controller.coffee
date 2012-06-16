app = controllers: AppController: prototype: ()->

class CONTROLLER_NAME extends app.controllers.AppController

	# action's draft template
	# ACTION_NAME:( ACTION_PARAMS )->

	## uncomment to implement user behaviours
	## customize to your needs
	# 
	# set_triggers():->
	# 	@el.click =( ev )-> _onclick ev
	# 
	# onclick:( ev )->
	#	console.log 'onclick'
	# 	console.log ev.target
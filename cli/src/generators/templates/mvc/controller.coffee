#<< app/app_controller
#<< app/models/~MODEL_LCASE

class app.controllers.~NAME_CAMEL extends app.AppController

	{~MODEL_CAMEL} = app.models

	### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		DEFAULT ACTION BEHAVIOR
		Override it to take control and customize as you wish
	~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###

	# <action-name>:()->
	# 	if ~MODEL_CAMEL.all?
	# 		@render "~NAME_LC/<action-name>", ~MODEL_CAMEL.all()
	# 	else
	# 		@render "~NAME_LC/<action-name>", null

	### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		EXAMPLES
	~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###

	# list:()->
	# 	@render "~NAME_LC/list", ~MODEL_CAMEL.all()

	# create:()->
	# 	@render "~NAME_LC/create", null
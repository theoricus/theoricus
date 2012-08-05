#<< theoricus/utils/string_util

###
	Router Logic inspired by RouterJS:
	https://github.com/haithembelhaj/RouterJs
###

class theoricus.core.Route
	Factory = null
	StringUtil = theoricus.utils.StringUtil

	@named_param_reg: /:\w+/g
	@splat_param_reg: /\*\w+/g

	api: null
	location: null

	constructor:( route, to, at, el, router )->
		Factory = router.the.factory
		
		@raw = route:route, to:to, at:at

		@matcher = route.replace Route.named_param_reg, '([^\/]+)'
		@matcher = @matcher.replace Route.splat_param_reg, '(.*?)'
		@matcher = new RegExp "^#{@matcher}$"

		@api = {}
		@api.controller_name = to.split( "/" )[0]
		@api.controller = Factory.controller @api.controller_name
		@api.action = to.split( "/" )[1]

		@target_route = at
		@target_el = el

	run:( after_run )->
		@api.controller._run @, after_run

	destroy:( after_destroy )->
		@api.controller._destroy @, after_destroy

	set_location:( location )->
		@location = location
		@api.params = @matcher.exec( location ).slice 1
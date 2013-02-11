## Router & Route logic inspired by RouterJS:
## https://github.com/haithembelhaj/RouterJs

class Route

  # static regex for reuse
  @named_param_reg: /:\w+/g
  @splat_param_reg: /\*\w+/g

  # variables
  api: null
  location: null

  constructor:( @match, @to, @at, @el, @router, @location = null )->
    @matcher = @match.replace Route.named_param_reg, '([^\/]+)'
    @matcher = @matcher.replace Route.splat_param_reg, '(.*?)'
    @matcher = new RegExp "^#{@matcher}$"

    @api = {}
    try
      @api.controller_name = to.split( "/" )[0]
      @api.action_name = to.split( "/" )[1]
    catch error
      console.log "TODO: handle error"

    @api.params = (@matcher.exec( location ).slice 1 if location?) or []

  ###
  @param [String] location
  ###
  clone:( location )->
    new Route @match, @to, @at, @el, @router, location
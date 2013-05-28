## Router & Route logic inspired by RouterJS:
## https://github.com/haithembelhaj/RouterJs

module.exports = class Route

  # static regex for reuse
  @named_param_reg: /:\w+/g
  @splat_param_reg: /\*\w+/g

  # variables
  api: null
  location: null

  constructor:( @match, @to, @at, @el, @router, @location = null )->

    # prepare regex matcher
    @matcher = @match.replace Route.named_param_reg, '([^\/]+)'
    @matcher = @matcher.replace Route.splat_param_reg, '(.*?)'
    @matcher = new RegExp "^#{@matcher}$"

   # init api object
    @api = params: null

    # fitlers controller and action name
    try
      @api.controller_name = to.split( "/" )[0]
      @api.action_name = to.split( "/" )[1]
    catch error
      console.log "TODO: handle error"

     # filters route's params names
    if (param_names = @match.match /(:|\*)\w+/g)?
      for value, index in param_names
        param_names[index] = value.substr 1 

    # filters route's param values
    param_values = (@matcher.exec( @location ).slice 1 if @location?) or []

    # merges both into a key/val dictionary for all route's params
    if param_values.length
      params = {}
      for value, index in param_values
        params[param_names[index]] = value

    # injects it into the api
    @api.params = params or {}

  # inject params directly into the route
  inject_params:( params )->
    for key, val of params
      unless @api.params[key]?
        @api.params[key] = val

  ###
  @param [String] location
  ###
  clone:( location )->
    new Route @match, @to, @at, @el, @router, location
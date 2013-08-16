###*
  Core module
  @module core
###


###*
  
  Responsible for manipulating and validating the url state.

  Stores the data defined in the application config `routes.coffee` file.

  @class Route
###
module.exports = class Route

  ###*

    Match named params.

    @static
    @property named_param_reg {RegExp}
    @example
      "works/:id".match Route.named_param_reg # matchs ':id'
  ###
  @named_param_reg: /:\w+/g

  ###*

    Match wildcard params.

    @static
    @property splat_param_reg {RegExp}

    @example
      "works/*anything/from/here".match Route.named_param_reg # matchs '*anything/from/here'
  ###
  @splat_param_reg: /\*\w+/g

  ###*

    Regex responsible for parsing the url state.

    @property matcher {RegExp}
  ###
  matcher: null

  ###*

    Url state.

    @property match {String}
  ###
  match: null

  ###*

    Controller '/' action to which the route will be sent.
    
    @property to {String}
  ###
  to: null

  ###*

    Route to be called as a dependency.
    
    @property at {String}
  ###
  at: null

  ###*

    CSS selector to define where the template will be rendered.
    
    @property el {String}
  ###
  el: null

  ###*

    Store the controller name extracted from url.
    
    @property controller_name {String}
  ###
  controller_name: null

  ###*

    Store the controllers' action name extracted from url.
    
    @property action_name {String}
  ###
  action_name: null

  ###*

    Store the controllers' action parameters extracted from url.
    
    @property param_names {String}
  ###
  param_names: null

  ###*
    @class Route
    @constructor
    @param @match {String} Url state.
    @param @to {String} {{#crossLink "Controller"}}__Controller's__{{/crossLink}} action (controller/action)  to which the route will be sent.
    @param @at {String} {{#crossLink "Route"}}__Route__{{/crossLink}} to be called as a dependency.
    @param @el {String} CSS selector to define where the template will be rendered.
  ###
  constructor:( @match, @to, @at, @el )->

    # prepare regex matcher str for reuse
    # Add regexp to ignore the last "slash"
    @matcher = @match.replace Route.named_param_reg, '([^\/]+)'
    @matcher = @matcher.replace Route.splat_param_reg, '(.*?)'
    @matcher = new RegExp "^#{@matcher}$", 'm'

    # fitlers controller and action name
    [@controller_name, @action_name] = to.split '/'

  ###*
  
    Extract the url named parameters.

    @method extract_params
    @param url {String}

    @example
For a route `pages/:id`, extract the `:id` from `pages/1`

    extract_params('pages/1') # returns {id:1}

  ###
  extract_params:( url )->
    # initialize empty params object
    params = {}

    # filters route's params names
    if (param_names = @match.match /(:|\*)\w+/g)?
      for value, index in param_names
        param_names[index] = value.substr 1
    else
      param_names = []

    # extract url params based on route
    params_values = (url.match @matcher)?.slice 1 or []

    # mounts params object with key->values pairs
    if params_values?
      for val, index in params_values
        key = param_names[ index ]
        params[key] = val

    return params

  ###*
    Returns a string with the url param names replaced by param values.

    @method rewrite_url_with_parms
    @param url {String}
    @param params {Object}

    @example
        rewrite_url_with_parms('pages/:id', {id:1}) # returns 'pages/1'

  ###
  rewrite_url_with_parms:( url, params )->
    for key, value of params
      reg = new RegExp "[:\\*]+#{key}", 'g'
      url = url.replace reg, value
    return url

  ###*

    Test given url using the {{#crossLink "Route/matcher:property"}} __@matcher__ {{/crossLink}} regexp.
    
    @method test
    @param url {String} Url to be tested.
  ###
  test:( url )->
    @matcher.test url
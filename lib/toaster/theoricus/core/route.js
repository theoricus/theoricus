(function() {

  theoricus.core.Route = (function() {

    Route.named_param_reg = /:\w+/g;

    Route.splat_param_reg = /\*\w+/g;

    Route.prototype.api = null;

    Route.prototype.location = null;

    function Route(match, to, at, el, router, location) {
      this.match = match;
      this.to = to;
      this.at = at;
      this.el = el;
      this.router = router;
      this.location = location != null ? location : null;
      this.matcher = this.match.replace(Route.named_param_reg, '([^\/]+)');
      this.matcher = this.matcher.replace(Route.splat_param_reg, '(.*?)');
      this.matcher = new RegExp("^" + this.matcher + "$");
      this.api = {};
      try {
        this.api.controller_name = to.split("/")[0];
        this.api.action_name = to.split("/")[1];
      } catch (error) {
        console.log("TODO: handle error");
      }
      this.api.params = (location != null ? this.matcher.exec(location).slice(1) : void 0) || [];
    }

    /*
      @param [String] location
    */


    Route.prototype.clone = function(location) {
      return new Route(this.match, this.to, this.at, this.el, this.router, location);
    };

    return Route;

  })();

}).call(this);

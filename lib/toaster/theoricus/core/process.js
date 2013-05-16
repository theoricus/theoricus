
/*
Responsible for "running" a [theoricus.core.Route] Route

 @author {https://github.com/arboleya arboleya}
*/


(function() {

  theoricus.core.Process = (function() {
    var StringUtil;

    StringUtil = theoricus.utils.StringUtil;

    Process.prototype.controller = null;

    Process.prototype.route = null;

    /*
      Instantiate controller responsible for the route
      
      @param [theoricus.Theoricus] @the   Shortcut for current app's instace
      @route [theoricus.core.Route] @route Route responsible for the process
    */


    function Process(the, route) {
      this.the = the;
      this.route = route;
      this.controller = this.the.factory.controller(this.route.api.controller_name);
    }

    /*
      Executes controller's action, in case it isn't declared executes an 
      standard one.
      
      @return [theoricus.mvc.View] view
    */


    Process.prototype.run = function(after_run) {
      var action, controller_name, msg,
        _this = this;
      if (!this.controller[action = this.route.api.action_name]) {
        /*
              Build a default action ( renders the view passing all model records as data)
              in case the controller doesn't have an action for current process call
        */

        this.controller[action] = function() {
          var api, model, model_name, view_folder, view_name;
          api = _this.route.api;
          model_name = api.controller_name.singularize().camelize();
          model = app.models[model_name];
          view_folder = api.controller_name.singularize();
          view_name = api.action_name;
          if (model.all != null) {
            return _this.controller.render("" + view_folder + "/" + view_name, model.all());
          } else {
            return _this.controller.render("" + view_folder + "/" + view_name, null);
          }
        };
      }
      this.controller.process = this;
      this.after_run = function() {
        _this.controller.process = null;
        return after_run();
      };
      this.view = this.controller[action].apply(this.controller, this.route.api.params);
      if (!(this.view instanceof theoricus.mvc.View)) {
        controller_name = this.route.api.controller_name.camelize();
        msg = "Check your `" + controller_name + "` controller, the action ";
        msg += "`" + action + "` must return a View instance.";
        return console.error(msg);
      }
    };

    /*
      Executes view's transition "out" method, wait for its end
      empty the dom element and then call a callback
      
      @return [theoricus.mvc.View] view
    */


    Process.prototype.destroy = function(after_destroy) {
      var action_name, controller_name, msg, shout, view_didnt_shout,
        _this = this;
      this.after_destroy = after_destroy;
      if (!(this.view instanceof theoricus.mvc.View)) {
        controller_name = this.route.api.controller_name.camelize();
        action_name = this.route.api.action_name;
        msg = "Can't destroy View because it isn't a proper View instance. ";
        msg += "Check your `" + controller_name + "` controller, the action ";
        msg += "`" + action_name + "` must return a View instance.";
        console.error(msg);
        return;
      }
      view_didnt_shout = true;
      shout = function(type) {
        if (view_didnt_shout === false) {
          console.warn('You can only request one shout.');
        }
        return;
        view_didnt_shout = false;
        return function() {
          _this.view.destroy();
          return typeof _this.after_destroy === "function" ? _this.after_destroy() : void 0;
        };
      };
      view.out(shout);
      if (view_didnt_shout) {
        return shout()('automaticaly');
      }
    };

    return Process;

  })();

}).call(this);

(function() {

  theoricus.mvc.Controller = (function() {
    var Fetcher, Model, View, _ref;

    function Controller() {}

    Fetcher = theoricus.mvc.lib.Fetcher;

    _ref = theoricus.mvc, Model = _ref.Model, View = _ref.View;

    /*
      @param [theoricus.Theoricus] @the   Shortcut for app's instance
    */


    Controller.prototype._boot = function(the) {
      this.the = the;
      return this;
    };

    /*
      Renders view
    
      @param [String] path  path to view on the app tree
      @param [String] data  data to be rendered on the template
      @param [Object] element element where it will be rendered, defaults to @process.route.el
    */


    Controller.prototype.render = function(path, data, el, view) {
      var shout, view_didnt_shout,
        _this = this;
      if (el == null) {
        el = this.process.route.el;
      }
      view = view || this.the.factory.view(path, this.process);
      if (data instanceof Fetcher) {
        if (data.loaded) {
          view.render(data.records, el);
        } else {
          data.onload = function(records) {
            return _this.render(path, records, el, view);
          };
        }
      } else {
        view.render(data, el);
        view_didnt_shout = true;
        shout = function(type) {
          if (view_didnt_shout === false) {
            return;
          }
          view_didnt_shout = false;
          return view.process.after_run;
        };
        view["in"](shout);
        if (view_didnt_shout) {
          shout()('automaticaly');
        }
      }
      return view;
    };

    return Controller;

  })();

}).call(this);

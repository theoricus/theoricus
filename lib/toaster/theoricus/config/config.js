(function() {

  theoricus.config.Config = (function() {

    Config.prototype.animate_at_startup = false;

    Config.prototype.enable_auto_transitions = true;

    Config.prototype.app_name = null;

    Config.prototype.no_push_state = null;

    Config.prototype.disable_transitions = null;

    /*
      @param [theoricus.Theoricus] @the   Shortcut for app's instance
    */


    function Config(the) {
      var _ref, _ref1, _ref2;
      this.the = the;
      this.app_name = "app";
      this.disable_transitions = (_ref = app.config.disable_transitions) != null ? _ref : false;
      this.animate_at_startup = (_ref1 = app.config.animate_at_startup) != null ? _ref1 : true;
      this.enable_auto_transitions = (_ref2 = app.config.enable_auto_transitions) != null ? _ref2 : true;
      this.vendors = app.config.vendors;
    }

    return Config;

  })();

}).call(this);

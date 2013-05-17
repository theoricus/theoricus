(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  theoricus.core.Processes = (function() {
    var ArrayUtil, Factory;

    Factory = null;

    ArrayUtil = theoricus.utils.ArrayUtil;

    Processes.prototype.locked = false;

    Processes.prototype.disable_transitions = null;

    Processes.prototype.active_processes = [];

    Processes.prototype.dead_processes = [];

    Processes.prototype.pending_processes = [];

    /*
      @param [theoricus.Theoricus] @the   Shortcut for app's instance
    */


    function Processes(the) {
      var _this = this;
      this.the = the;
      this._run_pending_processes = __bind(this._run_pending_processes, this);

      this._destroy_dead_processes = __bind(this._destroy_dead_processes, this);

      this._on_router_change = __bind(this._on_router_change, this);

      Factory = this.the.factory;
      if (this.the.config.animate_at_startup === false) {
        this.disable_transitions = this.the.config.disable_transitions;
        this.the.config.disable_transitions = true;
      }
      $(document).ready(function() {
        return _this.router = new theoricus.core.Router(_this.the, _this._on_router_change);
      });
    }

    /*
      1st
    
      Triggered on router chance
    
      @param [theoricus.core.Router] route
    */


    Processes.prototype._on_router_change = function(route) {
      var process;
      if (this.locked) {
        return this.router.navigate(this.last_process.route.location, 0, 1);
      }
      process = new theoricus.core.Process(this.the, route);
      this.last_process = process;
      this.locked = true;
      this.the.crawler.is_rendered = false;
      this._filter_pending_processes(process);
      this._filter_dead_processes();
      return this._destroy_dead_processes();
    };

    /*
      2nd
    
      Check if target scope ( for rendering ) exists
      If yes adds it to pending_process list
      If no  throws an error
    
      @param [theoricus.core.Process] process
    */


    Processes.prototype._filter_pending_processes = function(process) {
      var route, _results;
      this.pending_processes = [process];
      _results = [];
      while (process && process.route.at) {
        route = ArrayUtil.find(this.router.routes, {
          match: process.route.at
        });
        if (route != null) {
          process = new theoricus.core.Process(this.the, route.item.clone());
          this.pending_processes.push(process);
          if (route.target_route === null) {
            break;
          } else {
            _results.push(void 0);
          }
        } else {
          console.log("ERROR: Dependency not found at=" + process.route.at);
          console.log(process.route);
          break;
        }
      }
      return _results;
    };

    /*
      3th
    
      Check which of the routes needs to stay active in order to render
      current process.
      The ones that doesn't, are pushed to dead_processes
    */


    Processes.prototype._filter_dead_processes = function() {
      var active, found, location, search, _i, _len, _ref, _results;
      this.dead_processes = [];
      _ref = this.active_processes;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        active = _ref[_i];
        search = {
          route: {
            match: active.route.match
          }
        };
        found = ArrayUtil.find(this.pending_processes, search);
        if (found != null) {
          location = found.item.route.location;
          if ((location != null) && location !== active.route.location) {
            _results.push(this.dead_processes.push(active));
          } else {
            _results.push(void 0);
          }
        } else {
          _results.push(this.dead_processes.push(active));
        }
      }
      return _results;
    };

    /*
      4th
    
      Destroy dead processes one by one ( passing the next destroy as callback )
      then run the pending proccess
    */


    Processes.prototype._destroy_dead_processes = function() {
      var process, search;
      if (this.dead_processes.length) {
        process = this.dead_processes.pop();
        process.destroy(this._destroy_dead_processes);
        search = {
          route: {
            match: process.route.match
          }
        };
        return ArrayUtil["delete"](this.active_processes, search);
      } else {
        return this._run_pending_processes();
      }
    };

    /*
      5th
      Execute run method of pending processes that are not active
    */


    Processes.prototype._run_pending_processes = function() {
      var found, process, search;
      if (this.pending_processes.length) {
        process = this.pending_processes.pop();
        search = {
          route: {
            match: process.route.match
          }
        };
        found = ArrayUtil.find(this.active_processes, search) != null;
        if (!found) {
          this.active_processes.push(process);
          return process.run(this._run_pending_processes);
        } else {
          return this._run_pending_processes();
        }
      } else {
        this.locked = false;
        this.the.crawler.is_rendered = true;
        if (this.disable_transitions != null) {
          this.the.config.disable_transitions = this.disable_transitions;
          return this.disable_transitions = null;
        }
      }
    };

    return Processes;

  })();

}).call(this);


var __t;

__t = function(ns) {
  var curr, index, part, parts, _i, _len;
  curr = null;
  parts = [].concat = ns.split(".");
  for (index = _i = 0, _len = parts.length; _i < _len; index = ++_i) {
    part = parts[index];
    if (curr === null) {
      curr = eval(part);
      continue;
    } else {
      if (curr[part] == null) {
        curr = curr[part] = {};
      } else {
        curr = curr[part];
      }
    }
  }
  return curr;
};

var theoricus = window.theoricus = {};


(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  __t('theoricus.utils').StringUtil = (function() {

    function StringUtil() {}

    StringUtil.ucfirst = function(str) {
      var a, b;
      a = str.substr(0, 1).toUpperCase();
      b = str.substr(1).toLowerCase();
      return a + b;
    };

    StringUtil.camelize = function(str) {
      var buffer, part, parts, _i, _len, _results;
      parts = [].concat(str.split("_"));
      buffer = "";
      _results = [];
      for (_i = 0, _len = parts.length; _i < _len; _i++) {
        part = parts[_i];
        _results.push(buffer += StringUtil.ucfirst(part));
      }
      return _results;
    };

    StringUtil.underscore = function(str) {
      str = str.replace(/([A-Z])/g, "_$1").toLowerCase();
      return str = str.substr(1) === "_" ? str.substr(1) : str;
    };

    return StringUtil;

  })();

  /*
  	Router Logic inspired by RouterJS:
  	https://github.com/haithembelhaj/RouterJs
  */


  __t('theoricus.core').Route = (function() {
    var Factory, StringUtil;

    Factory = null;

    StringUtil = theoricus.utils.StringUtil;

    Route.named_param_reg = /:\w+/g;

    Route.splat_param_reg = /\*\w+/g;

    Route.prototype.api = null;

    Route.prototype.location = null;

    function Route(route, to, at, el, router) {
      Factory = router.the.factory;
      this.raw = {
        route: route,
        to: to,
        at: at
      };
      this.matcher = route.replace(Route.named_param_reg, '([^\/]+)');
      this.matcher = this.matcher.replace(Route.splat_param_reg, '(.*?)');
      this.matcher = new RegExp("^" + this.matcher + "$");
      this.api = {};
      this.api.controller_name = to.split("/")[0];
      this.api.controller = Factory.controller(this.api.controller_name);
      this.api.action = to.split("/")[1];
      this.target_route = at;
      this.target_el = el;
    }

    Route.prototype.run = function(after_run) {
      return this.api.controller._run(this, after_run);
    };

    Route.prototype.destroy = function(after_destroy) {
      return this.api.controller._destroy(this, after_destroy);
    };

    Route.prototype.set_location = function(location) {
      this.location = location;
      return this.api.params = this.matcher.exec(location).slice(1);
    };

    return Route;

  })();

  __t('theoricus.utils').ObjectUtil = (function() {

    function ObjectUtil() {}

    ObjectUtil.find = function(src, search) {
      var k, v;
      for (k in search) {
        v = search[k];
        if (v instanceof Object) {
          return ObjectUtil.find(src[k], v);
        }
        if (src[k] === v) {
          return src;
        }
      }
      return null;
    };

    return ObjectUtil;

  })();

  /*
  	Router Logic inspired by RouterJS:
  	https://github.com/haithembelhaj/RouterJs
  */


  __t('theoricus.core').Router = (function() {
    var Factory;

    Factory = null;

    Router.prototype.routes = [];

    Router.prototype.listeners = [];

    Router.prototype.trigger = true;

    function Router(the, on_change) {
      var opts, route, _ref,
        _this = this;
      this.the = the;
      this.on_change = on_change;
      Factory = this.the.factory;
      _ref = app.routes;
      for (route in _ref) {
        opts = _ref[route];
        this.map(route, opts.to, opts.at, opts.el, this);
      }
      History.Adapter.bind(window, 'statechange', function() {
        return _this.route(History.getState());
      });
      setTimeout(function() {
        var url;
        url = window.location.pathname;
        if (url === "/") {
          url = app.root;
        }
        return _this.run(url);
      }, 1);
    }

    Router.prototype.map = function(route, to, at, el) {
      return this.routes.push(new theoricus.core.Route(route, to, at, el, this));
    };

    Router.prototype.route = function(state) {
      var route, url, _i, _len, _ref;
      if (this.trigger) {
        url = state.title || state.hash;
        if (url === "/") {
          url = app.root;
        }
        _ref = this.routes;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          route = _ref[_i];
          if (route.matcher.test(url)) {
            route.set_location(url);
            if (typeof this.on_change === "function") {
              this.on_change(route);
            }
            return;
          }
        }
      }
      return this.trigger = true;
    };

    Router.prototype.navigate = function(url, trigger, replace) {
      var action;
      if (trigger == null) {
        trigger = true;
      }
      if (replace == null) {
        replace = false;
      }
      if (this.the.config.no_push_state) {
        window.location = url;
      } else {
        this.trigger = trigger;
        action = replace ? "replaceState" : "pushState";
        return History[action](null, url, url);
      }
    };

    Router.prototype.run = function(url, trigger) {
      if (trigger == null) {
        trigger = true;
      }
      this.trigger = trigger;
      return this.route({
        title: url
      });
    };

    Router.prototype.go = function(index) {
      return History.go(index);
    };

    Router.prototype.back = function() {
      return History.back();
    };

    Router.prototype.forward = function() {
      return History.forward();
    };

    return Router;

  })();

  __t('theoricus.utils').ArrayUtil = (function() {
    var ObjectUtil;

    function ArrayUtil() {}

    ObjectUtil = theoricus.utils.ObjectUtil;

    ArrayUtil.find = function(src, search) {
      var i, v, _i, _len;
      for (i = _i = 0, _len = src.length; _i < _len; i = ++_i) {
        v = src[i];
        if (search instanceof String) {
          if (v === search) {
            return {
              item: v,
              index: i
            };
          }
        } else if (search instanceof Object) {
          if (ObjectUtil.find(v, search) != null) {
            return {
              item: v,
              index: i
            };
          }
        }
      }
      return null;
    };

    ArrayUtil["delete"] = function(src, search) {
      var item;
      item = ArrayUtil.find(src, search);
      if (item != null) {
        return src.splice(item.index, 1);
      }
    };

    return ArrayUtil;

  })();

  __t('theoricus.mvc').Model = (function() {

    function Model() {}

    Model.prototype._boot = function(the) {
      this.the = the;
      return this;
    };

    return Model;

  })();

  __t('theoricus.mvc').View = (function() {
    var Factory;

    function View() {}

    Factory = null;

    View.prototype._boot = function(the) {
      this.the = the;
      Factory = this.the.factory;
      return this;
    };

    View.prototype._render = function(route, auto_tmpl_name, data) {
      this.route = route;
      this.data = data != null ? data : {};
      this.el = $(this.route.target_el);
      if (this.render) {
        this.render(data);
      } else {
        this.render_template(auto_tmpl_name, data);
      }
      return typeof this.set_triggers === "function" ? this.set_triggers() : void 0;
    };

    View.prototype.render_template = function(template, data) {
      var dom;
      template = Factory.template(this.route.api.controller_name, template);
      dom = template(data);
      this.el.append(dom);
      return this["in"](this.after_in);
    };

    View.prototype["in"] = function(after_in) {
      var animate,
        _this = this;
      animate = !this.the.config.enable_auto_transitions;
      animate || (animate = this.the.config.disable_transitions);
      animate || (animate = this.the.config.disable_auto_transitions);
      if (animate) {
        return typeof after_in === "function" ? after_in() : void 0;
      } else {
        this.el.css("opacity", 0);
        return this.el.animate({
          opacity: 1
        }, 600, function() {
          return typeof after_in === "function" ? after_in() : void 0;
        });
      }
    };

    View.prototype.out = function(after_out) {
      var animate;
      animate = !this.the.config.enable_auto_transitions;
      animate || (animate = this.the.config.disable_transitions);
      animate || (animate = this.the.config.disable_auto_transitions);
      if (animate) {
        return typeof after_out === "function" ? after_out() : void 0;
      } else {
        return this.el.animate({
          opacity: 0
        }, 300, after_out);
      }
    };

    View.prototype.navigate = function(url) {
      return this.the.processes.router.navigate(url);
    };

    return View;

  })();

  __t('theoricus.mvc').Controller = (function() {
    var Factory, StringUtil;

    function Controller() {}

    Factory = null;

    StringUtil = theoricus.utils.StringUtil;

    Controller.prototype._boot = function(the) {
      this.the = the;
      Factory = this.the.factory;
      return this;
    };

    Controller.prototype._run = function(route, after_run) {
      var model;
      this.route = route;
      this.after_run = after_run;
      if (this[this.route.api.action] != null) {
        return this[this.route.api.action].apply(this, this.route.api.params);
      } else {
        model = Factory.model(this.route.api.controller_name);
        return this.render(this.route.api.action, model);
      }
    };

    Controller.prototype._destroy = function(route, after_destroy) {
      var _this = this;
      route.view.after_out = after_destroy;
      return route.view.out(function() {
        var _base;
        $(route.view.el).empty();
        return typeof (_base = route.view).after_out === "function" ? _base.after_out() : void 0;
      });
    };

    Controller.prototype.render = function(view_name, data) {
      this.route.view = Factory.view(this.route.api.controller_name, view_name);
      this.route.view.after_in = this.after_run;
      return this.route.view._render(this.route, view_name, {
        data: data
      });
    };

    return Controller;

  })();

  __t('theoricus.config').Config = (function() {

    Config.prototype.animate_at_startup = false;

    Config.prototype.enable_auto_transitions = true;

    Config.prototype.app_name = null;

    Config.prototype.no_push_state = null;

    Config.prototype.disable_transitions = null;

    function Config(the) {
      this.the = the;
      this.app_name = "app";
      this.animate_at_startup = app.config.animate_at_startup || false;
      this.disable_auto_transitions = app.disable_auto_transitions || true;
      this.no_push_state = typeof history.pushState === !'function';
      this.no_push_state || (this.no_push_state = /(\?|\&)(crawler)/.test(window.location));
      this.disable_transitions = this.no_push_state;
    }

    return Config;

  })();

  __t('theoricus.core').Factory = (function() {
    var StringUtil;

    Factory.prototype.controllers = {};

    StringUtil = theoricus.utils.StringUtil;

    function Factory(the) {
      var app_name;
      this.the = the;
      app_name = this.the.config.app_name;
      this.c_tmpl = "" + app_name + ".controllers.{classname}Controller";
      this.m_tmpl = "" + app_name + ".models.{classname}Model";
      this.v_tmpl = "" + app_name + ".views.{ns}.{classname}View";
      this.t_tmpl = "{ns}-{name}";
    }

    Factory.prototype.controller = function(name) {
      var classpath, controller;
      console.log("Factory.controller( '" + name + "' )");
      name = StringUtil.camelize(name);
      if (this.controllers[name] != null) {
        return this.controllers[name];
      } else {
        classpath = this.c_tmpl.replace("{classname}", name);
        controller = eval(classpath);
        controller = new controller;
        controller._boot(this.the);
        return this.controllers[name] = controller;
      }
    };

    Factory.prototype.model = function(name) {
      var classpath, model;
      name = StringUtil.camelize(name);
      classpath = this.m_tmpl.replace("{classname}", name);
      model = eval(classpath);
      model = new model;
      return model._boot(this.the);
    };

    Factory.prototype.view = function(ns, name) {
      var classpath, view;
      name = StringUtil.camelize(name);
      classpath = this.v_tmpl.replace("{ns}", ns).replace("{classname}", name);
      view = eval(classpath);
      view = new view;
      return view._boot(this.the);
    };

    Factory.prototype.template = function(ns, name) {
      var path;
      path = this.t_tmpl.replace("{ns}", ns).replace(/\{name\}/g, name);
      console.log("Factory.template( '" + path + "' )");
      return app.templates[path];
    };

    return Factory;

  })();

  __t('theoricus.core').Processes = (function() {
    var ArrayUtil, Factory;

    Factory = null;

    ArrayUtil = theoricus.utils.ArrayUtil;

    Processes.prototype.locked = false;

    Processes.prototype.disable_transitions = null;

    Processes.prototype.active_processes = [];

    Processes.prototype.dead_processes = [];

    Processes.prototype.pending_processes = [];

    function Processes(the) {
      this.the = the;
      this._run_pending_processes = __bind(this._run_pending_processes, this);

      this._destroy_dead_processes = __bind(this._destroy_dead_processes, this);

      this._on_router_change = __bind(this._on_router_change, this);

      Factory = this.the.factory;
      if (this.the.config.animate_at_startup === false) {
        this.disable_transitions = this.the.config.disable_transitions;
        this.the.config.disable_transitions = true;
      }
      this.router = new theoricus.core.Router(this.the, this._on_router_change);
    }

    Processes.prototype._on_router_change = function(route) {
      if (this.locked) {
        return this.router.navigate(this.last_route.location, false, true);
      }
      this.last_route = route;
      this.locked = true;
      this.the.crawler.is_rendered = false;
      this._filter_pending_processes(route);
      this._filter_dead_processes();
      return this._destroy_dead_processes();
    };

    Processes.prototype._filter_pending_processes = function(route) {
      var search, _results;
      this.pending_processes = [route];
      _results = [];
      while (true && route && route.target_route) {
        search = {
          raw: {
            route: route.target_route
          }
        };
        route = ArrayUtil.find(this.router.routes, search);
        if (route != null) {
          route = route.item;
        }
        if (route != null) {
          this.pending_processes.push(route);
          if (route.target_route === null) {
            break;
          } else {
            _results.push(void 0);
          }
        } else {
          _results.push(void 0);
        }
      }
      return _results;
    };

    Processes.prototype._filter_dead_processes = function() {
      var found, route, search, _i, _len, _ref, _results;
      this.dead_processes = [];
      _ref = this.active_processes;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        route = _ref[_i];
        search = {
          raw: {
            route: route.raw.route
          }
        };
        found = ArrayUtil.find(this.pending_processes, search);
        if (found === null) {
          _results.push(this.dead_processes.push(route));
        } else {
          _results.push(void 0);
        }
      }
      return _results;
    };

    Processes.prototype._destroy_dead_processes = function() {
      var route, search;
      if (this.dead_processes.length) {
        route = this.dead_processes.pop();
        search = {
          raw: {
            route: route.raw.route
          }
        };
        ArrayUtil["delete"](this.active_processes, search);
        return route.destroy(this._destroy_dead_processes);
      } else {
        return this._run_pending_processes();
      }
    };

    Processes.prototype._run_pending_processes = function() {
      var route, search;
      if (this.pending_processes.length) {
        route = this.pending_processes.pop();
        search = {
          raw: {
            route: route.raw.route
          }
        };
        if (ArrayUtil.find(this.active_processes, search) == null) {
          this.active_processes.push(route);
          return route.run(this._run_pending_processes);
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

  __t('theoricus').Theoricus = (function() {

    Theoricus.prototype.app = null;

    Theoricus.prototype.root = null;

    Theoricus.prototype.factory = null;

    Theoricus.prototype.config = null;

    Theoricus.prototype.processes = null;

    Theoricus.prototype.crawler = (window.crawler = {
      is_rendered: false
    });

    function Theoricus() {
      this.config = new theoricus.config.Config(this);
      this.factory = new theoricus.core.Factory(this);
      this.processes = new theoricus.core.Processes(this);
    }

    return Theoricus;

  })();

}).call(this);


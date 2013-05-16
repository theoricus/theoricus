(function() {

  theoricus.core.Factory = (function() {
    var Controller, Model, View, _is, _ref;

    _ref = theoricus.mvc, Model = _ref.Model, View = _ref.View, Controller = _ref.Controller;

    Factory.prototype.controllers = {};

    /*
      @param [theoricus.Theoricus] @the   Shortcut for app's instance
    */


    function Factory(the) {
      this.the = the;
    }

    _is = function(src, comparison) {
      while (src = src.__proto__) {
        if (src instanceof comparison) {
          return true;
        }
        src = src.__proto__;
      }
      return false;
    };

    Factory.model = Factory.prototype.model = function(name, init) {
      var classname, classpath, klass, model, prop, value;
      if (init == null) {
        init = {};
      }
      classname = theoricus.utils.StringUtil.camelize(name);
      classpath = "app.models." + name;
      if ((klass = app.models[classname]) == null) {
        console.error('Model not found: ' + classpath);
        console.error('just tried classname: ' + classname);
      } else {
        if (!((model = new klass(init)) instanceof Model)) {
          console.error("" + classpath + " is not a Model instance - you probably forgot to extend thoricus.mvc.Model");
        }
      }
      if (model == null) {
        model = new app.AppModel(init);
      }
      model.classpath = classpath;
      model.classname = classname;
      for (prop in init) {
        value = init[prop];
        model[prop] = value;
      }
      return model;
    };

    /*
      Returns an instantiated [theoricus.mvc.View] View
    
      @param [String] path  path to the view file
      @param [theoricus.core.Process] process process responsible for the view
    */


    Factory.prototype.view = function(path, process) {
      var classname, classpath, klass, len, namespace, p, parts, view;
      if (process == null) {
        process = null;
      }
      klass = app.views;
      classpath = "app.views";
      classname = (parts = path.split('/')).pop();
      classname = theoricus.utils.StringUtil.camelize(classname);
      len = parts.length - 1;
      namespace = parts[len];
      while (parts.length) {
        classpath += "." + (p = parts.shift());
        if (klass[p] != null) {
          klass = klass[p];
        } else {
          console.error("Namespace '" + p + " not found in app.views...");
        }
      }
      classpath += "." + classname;
      if ((klass = klass[classname]) == null) {
        console.error('View not found: ' + classpath);
      } else {
        if (!((view = new klass) instanceof View)) {
          console.error("" + classpath + " is not a View instance - you probably forgot to extend thoricus.mvc.View");
        }
      }
      if (view == null) {
        view = new app.AppView;
      }
      view._boot(this.the);
      view.classpath = classpath;
      view.classname = classname;
      view.namespace = namespace;
      if (process != null) {
        view.process = process;
      }
      return view;
    };

    /*
      Returns an instantiated [theoricus.mvc.Controller] Controller
    
      @param [String] name  controller name
    */


    Factory.prototype.controller = function(name) {
      var classname, classpath, controller, klass;
      classname = classname = theoricus.utils.StringUtil.camelize(name);
      classpath = "app.controllers." + classname;
      if (this.controllers[classname] != null) {
        return this.controllers[classname];
      } else {
        if ((klass = app.controllers[classname]) == null) {
          console.error('Controller not found: ' + classpath);
        }
        if (!((controller = new klass) instanceof Controller)) {
          console.error("" + classpath + " is not a Controller instance - you probably forgot to extend thoricus.mvc.Controller");
        }
        controller.classpath = classpath;
        controller.classname = classname;
        controller._boot(this.the);
        return this.controllers[classname] = controller;
      }
    };

    /*
      Returns a compiled jade template
    
      @param [String] path  path to the template
    */


    Factory.template = Factory.prototype.template = function(path) {
      if (app.templates[path] != null) {
        return app.templates[path];
      }
      if (app.templates['components/' + path] != null) {
        return app.templates['components/' + path];
      }
      return console.error("Factory::template not found for " + path);
    };

    return Factory;

  })();

}).call(this);

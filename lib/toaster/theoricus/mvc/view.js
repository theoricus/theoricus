(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  theoricus.mvc.View = (function() {
    var Factory;

    function View() {
      this.find = __bind(this.find, this);

      this.set_triggers = __bind(this.set_triggers, this);

      this.render = __bind(this.render, this);

    }

    Factory = null;

    View.prototype.el = null;

    View.prototype.classpath = null;

    View.prototype.classname = null;

    View.prototype.namespace = null;

    View.prototype.process = null;

    /*
      @param [theoricus.Theoricus] @the   Shortcut for app's instance
    */


    View.prototype._boot = function(the) {
      this.the = the;
      Factory = this.the.factory;
      return this;
    };

    /*
      @param [Object] @data   Data to be passed to the template
      @param [Object] @el     Element where the view will be "attached/appended"
    */


    View.prototype.render = function(data, el, template) {
      var api, dom, tmpl_folder, tmpl_name;
      this.data = data != null ? data : {};
      if (el == null) {
        el = this.process.route.el;
      }
      if (template == null) {
        template = null;
      }
      if (typeof this.before_render === "function") {
        this.before_render(this.data);
      }
      if (!this.el) {
        api = this.process.route.api;
        this.el = $(el);
        if (template === null) {
          tmpl_folder = this.namespace.singularize();
          tmpl_name = this.classname.underscore();
          template = Factory.template("" + tmpl_folder + "/" + tmpl_name);
        }
        if (template != null) {
          dom = template(this.data);
        }
        dom = this.el.append(dom);
        if (this.data instanceof theoricus.mvc.Model) {
          this.data.bind(dom, !this.the.config.autobind);
        }
      }
      if (typeof this.set_triggers === "function") {
        this.set_triggers();
      }
      if (typeof this.after_render === "function") {
        this.after_render(this.data);
      }
      /*
          In case you define an "on_resize" handler it will be automatically 
          binded and triggered
      */

      if (this.on_resize != null) {
        $(window).unbind('resize', this.on_resize);
        $(window).bind('resize', this.on_resize);
        return this.on_resize();
      }
    };

    /*
      In case you defined @events in your view they will be automatically binded
    */


    View.prototype.set_triggers = function() {
      var all, ev, funk, sel, _ref, _ref1, _results;
      if (!(this.events != null)) {
        return;
      }
      _ref = this.events;
      _results = [];
      for (sel in _ref) {
        funk = _ref[sel];
        _ref1 = sel.match(/(.*)[\s|\t]+([\S]+)$/m), all = _ref1[0], sel = _ref1[1], ev = _ref1[2];
        (this.el.find(sel)).unbind(ev, null, this[funk]);
        _results.push((this.el.find(sel)).bind(ev, null, this[funk]));
      }
      return _results;
    };

    /*
      Destroy the view after the 'out' animation, the default behavior is to just
      empty it's container element.
    
      before_destroy will be called just before emptying it.
    */


    View.prototype.destroy = function() {
      if (this.on_resize != null) {
        $(window).unbind('resize', this.on_resize);
      }
      if (typeof this.before_destroy === "function") {
        this.before_destroy();
      }
      return this.el.empty();
    };

    /*
      Should execute view transition in.
    
      In case you transition isn't syncoronous ( i.e. has animation )
      you should execute the method "shout" given as argument.
    
      It will it will return a callback which will notify the current process
      your view just got rendered ( i.e. animation finished )
    
      @param [Function] shout Return a framework "continue signal"
    
      NOTE: If you execute shout, and then cancel your transition, the framework
      will never now your view finished the transition in
    */


    View.prototype["in"] = function(shout) {
      var dont_have_transition;
      if (typeof this.before_in === "function") {
        this.before_in();
      }
      dont_have_transition = this.the.config.enable_auto_transitions;
      dont_have_transition &= !this.the.config.disable_transitions;
      if (dont_have_transition) {
        return;
      }
      this.el.css("opacity", 0);
      return this.el.animate({
        opacity: 1
      }, 600, typeof shout === "function" ? shout('view ') : void 0);
    };

    /*
      Should execute view transition out.
    
      In case you transition isn't syncoronous ( i.e. has animation )
      you should execute the method "shout" given as argument.
    
      It will it will return a callback which will notify the current process
      your view just got rendered ( i.e. animation finished )
    
      @param [Function] shout Return a framework "continue signal"
    
      NOTE: If you execute shout, and then cancel your transition, the framework
      will never now your view finished the transition in
    */


    View.prototype.out = function(shout) {
      var dont_have_transition;
      if (typeof this.before_out === "function") {
        this.before_out();
      }
      dont_have_transition = this.the.config.enable_auto_transitions;
      dont_have_transition &= !this.the.config.disable_transitions;
      if (dont_have_transition) {
        return;
      }
      return this.el.animate({
        opacity: 0
      }, 300, typeof shout === "function" ? shout('view') : void 0);
    };

    /*
      Shortcut for application navigate
    
      @param [String] url URL to navigate
    */


    View.prototype.navigate = function(url) {
      return this.the.processes.router.navigate(url);
    };

    /*
      Shortcut for Factory.view method
    
      @param [String] path    Path to view file
    */


    View.prototype.view = function(path) {
      return Factory.view(path, this.process);
    };

    /*
      Shortcut for Factory.template method
    
      @param [String] url Path to template file
    */


    View.prototype.template = function(path) {
      return Factory.template(path);
    };

    /*
      instantiates a view, render on container passing current data
    */


    View.prototype.require = function(view, container, data, template) {
      if (data == null) {
        data = this.data;
      }
      view = this.view(view);
      if (container) {
        view.render(data, this.el.find(container, template));
      }
      return view;
    };

    View.prototype.find = function(selector) {
      return this.el.find(selector);
    };

    /*
      Takes a selector or array of selectors
      Adds click event handler to each of them
    */


    View.prototype.link = function(a_selector) {
      var _this = this;
      return $(a_selector).each(function(index, selector) {
        return _this.find(selector).click(function(event) {
          _this.navigate($(event.delegateTarget).attr('href'));
          return false;
        });
      });
    };

    return View;

  })();

}).call(this);

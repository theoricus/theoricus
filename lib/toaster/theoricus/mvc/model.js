(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    __slice = [].slice;

  theoricus.mvc.Model = (function(_super) {
    var ArrayUtil;

    __extends(Model, _super);

    function Model() {
      return Model.__super__.constructor.apply(this, arguments);
    }

    ArrayUtil = theoricus.utils.ArrayUtil;

    Model._fields = [];

    Model._collection = [];

    Model.rest = function(host, resources) {
      var k, v, _ref, _results;
      if (resources == null) {
        _ref = [host, null], resources = _ref[0], host = _ref[1];
      }
      _results = [];
      for (k in resources) {
        v = resources[k];
        _results.push(this[k] = this._build_rest.apply(this, [k].concat(v.concat(host))));
      }
      return _results;
    };

    Model.fields = function(fields) {
      var key, type, _results;
      _results = [];
      for (key in fields) {
        type = fields[key];
        _results.push(this._build_gs(key, type));
      }
      return _results;
    };

    /*
      Builds a method to fetch the given service.
    
      Notice the method is being returned inside a private scope
      that contains all the variables needed to fetch the data.
    
      
      @param [String] key   
      @param [String] method  
      @param [String] url   
      @param [String] domain
    */


    Model._build_rest = function(key, method, url, domain) {
      var call;
      return call = function() {
        var args, data, found, r_url;
        args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
        if (key === "read" && this._collection.length) {
          found = ArrayUtil.find(this._collection, {
            id: args[0]
          });
          if (found != null) {
            return found.item;
          }
        }
        if (args.length) {
          if (typeof args[args.length - 1] === 'object') {
            data = args.pop();
          } else {
            data = '';
          }
        }
        r_url = url;
        while ((/:[a-z]+/.exec(r_url)) != null) {
          r_url = url.replace(/:[a-z]+/, args.shift() || null);
        }
        if (domain != null) {
          r_url = "" + domain + "/" + r_url;
        }
        return this._request(method, r_url, data);
      };
    };

    /*
      General request method
    
      @param [String] method  URL request method
      @param [String] url   URL to be requested
      @param [Object] data  Data to be send
    */


    Model._request = function(method, url, data) {
      var fetcher, req,
        _this = this;
      if (data == null) {
        data = '';
      }
      console.log("[Model] request", method, url, data);
      fetcher = new theoricus.mvc.lib.Fetcher;
      req = {
        url: url,
        type: method,
        data: data
      };
      if (/\.json/.test(url)) {
        req.dataType = 'json';
      }
      req = $.ajax(req);
      req.done(function(data) {
        fetcher.loaded = true;
        fetcher.records = _this._instantiate(data);
        return typeof fetcher.onload === "function" ? fetcher.onload(fetcher.records) : void 0;
      });
      req.error(function(error) {
        fetcher.error = true;
        if (fetcher.onerror != null) {
          return fetcher.onerror(error);
        } else {
          throw error;
        }
      });
      return fetcher;
    };

    /*
      Builds local getters/setters for the given params
    
      @param [String] field
      @param [String] type
    */


    Model._build_gs = function(field, type) {
      var classname, getter, ltype, setter, stype, _val;
      _val = null;
      classname = (("" + this).match(/function\s(\w+)/))[1];
      stype = (("" + type).match(/function\s(\w+)/))[1];
      ltype = stype.toLowerCase();
      getter = function() {
        return _val;
      };
      setter = function(value) {
        var f, msg, prop;
        switch (ltype) {
          case 'string':
            f = typeof value === 'string';
            break;
          case 'number':
            f = typeof value === 'number';
            break;
          default:
            f = value instanceof type;
        }
        if (f) {
          _val = value;
          return this.update(field, _val);
        } else {
          prop = "" + classname + "." + field;
          msg = "Property '" + prop + "' must to be " + stype + ".";
          throw new Error(msg);
        }
      };
      return Object.defineProperty(this.prototype, field, {
        get: getter,
        set: setter
      });
    };

    /*
      Instantiate one Model instance for each of the items present in data.
    
      And array with 10 items will result in 10 new models, that will be 
      cached into @_collection variable
    
      @param [Object] data  Data to be parsed
    */


    Model._instantiate = function(data) {
      var Factory, classname, model, record, records, _i, _len, _ref;
      Factory = theoricus.core.Factory;
      classname = (("" + this).match(/function\s(\w+)/))[1];
      records = [];
      _ref = [].concat(data);
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        record = _ref[_i];
        model = Factory.model(classname, record);
        records.push(model);
      }
      /*
          When calling the rest service multiple times, the collection variable keeps 
          the old data and duplicate the recordset between a rest call and another one.
          For now, just flush the old collection when instantiate a new model instance
      */

      this._collection = [];
      this._collection = (this._collection || []).concat(records);
      if (records.length === 1) {
        return records[0];
      } else {
        return records;
      }
    };

    return Model;

  })(theoricus.mvc.lib.Binder);

}).call(this);

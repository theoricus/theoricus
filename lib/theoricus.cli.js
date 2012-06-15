
var __t;

__t = function(ns, expose) {
  var curr, index, part, parts, _i, _len;
  curr = null;
  parts = [].concat = ns.split(".");
  for (index = _i = 0, _len = parts.length; _i < _len; index = ++_i) {
    part = parts[index];
    if (curr === null) {
      curr = eval(part);
      if (expose != null) {
        expose[part] = curr;
      }
      continue;
    } else {
      if (curr[part] == null) {
        curr = curr[part] = {};
        if (expose != null) {
          expose[part] = curr;
        }
      } else {
        curr = curr[part];
      }
    }
  }
  return curr;
};

var theoricus = exports.theoricus = {};


(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  __t('theoricus.commands', exports).Add = (function() {

    Add.name = 'Add';

    function Add(the, opts) {
      var action;
      this.the = the;
      action = opts[1];
      switch (action) {
        case "model":
          new theoricus.generators.Model(this.the, opts);
          break;
        case "view":
          new theoricus.generators.View(this.the, opts);
          break;
        case "controller":
          new theoricus.generators.Controller(this.the, opts);
          break;
        case "mvc":
          new theoricus.generators.Controller(this.the, opts);
          new theoricus.generators.Model(this.the, opts);
          new theoricus.generators.View(this.the, opts);
          break;
        default:
          console.log("ERROR: Valid options: controller,model,view,mvc.");
      }
    }

    return Add;

  })();

  __t('theoricus.commands', exports).AddProject = (function() {
    var exec, path, pn;

    AddProject.name = 'AddProject';

    path = require('path');

    pn = path.normalize;

    exec = (require("child_process")).exec;

    function AddProject(the, options) {
      var cmd,
        _this = this;
      this.the = the;
      this.options = options;
      this.pwd = this.the.pwd;
      this.root = this.the.root;
      this.app_skel = pn("" + this.root + "/cli/theoricus/generators/templates/app_skel");
      this.target = pn("" + this.pwd + "/" + this.options[1]);
      if (path.existsSync(this.target)) {
        console.log("ERROR: Target directory already existis. Do you " + "wanna overwrite it? You'll lose everything.");
        return;
      }
      cmd = "cp -r " + this.app_skel + " " + this.target;
      exec(cmd, function(error, stdout, stderr) {
        if (error != null) {
          return console.log(error);
        } else {
          return exec("find " + _this.target, function(error, stdout, stderr) {
            var file, files, _i, _len, _results;
            files = stdout.split("\n").slice(0, -1);
            _results = [];
            for (_i = 0, _len = files.length; _i < _len; _i++) {
              file = files[_i];
              _results.push(console.log(("" + 'Created'.bold + " " + file).green));
            }
            return _results;
          });
        }
      });
    }

    return AddProject;

  })();

  __t('theoricus.commands', exports).Compiler = (function() {
    var ArrayUtil, FsUtil, Toaster, fs, jade, path, stylus;

    Compiler.name = 'Compiler';

    path = require("path");

    fs = require("fs");

    jade = require("jade");

    stylus = require("stylus");

    Toaster = require('coffee-toaster').Toaster;

    FsUtil = require('coffee-toaster').toaster.utils.FsUtil;

    ArrayUtil = require('coffee-toaster').toaster.utils.ArrayUtil;

    Compiler.prototype.BASE_DIR = "";

    Compiler.prototype.APP_FOLDER = "";

    function Compiler(the, options) {
      var config;
      this.the = the;
      this._on_jade_stylus_change = __bind(this._on_jade_stylus_change, this);

      this.BASE_DIR = this.the.pwd;
      this.APP_FOLDER = "" + this.BASE_DIR + "/app";
      config = {
        folders: {},
        vendors: ["" + this.the.root + "/vendors/jquery.js", "" + this.the.root + "/vendors/history.js", "" + this.the.root + "/vendors/history.adapter.native.js", "" + this.the.root + "/vendors/jade.runtime.js"],
        release: "public/app.js",
        debug: "public/app-debug.js"
      };
      config.folders[this.APP_FOLDER] = "app";
      config.folders["" + this.the.root + "/src"] = "theoricus";
      this.toaster = new Toaster(this.BASE_DIR, {
        w: 1,
        d: 1,
        config: config
      }, true);
      this.compile();
      FsUtil.watch_folder(this.APP_FOLDER, /.jade$/, this._on_jade_stylus_change);
      FsUtil.watch_folder(this.APP_FOLDER, /.styl$/, this._on_jade_stylus_change);
    }

    Compiler.prototype._on_jade_stylus_change = function(info) {
      var msg, type;
      if (info.action === "watching") {
        return;
      }
      if (info.type === "folder" && info.action === "created") {
        return;
      }
      switch (info.action) {
        case "created":
          msg = "New file created".bold.cyan;
          console.log("" + msg + " " + info.path.green);
          break;
        case "deleted":
          type = info.type === "file" ? "File" : "Folder";
          msg = ("" + type + " deleted").bold.red;
          console.log("" + msg + " " + info.path.red);
          break;
        case "updated":
          msg = "File changed".bold.cyan;
          console.log("" + msg + " " + info.path.cyan);
      }
      return this.compile();
    };

    Compiler.prototype.compile_jade = function(after_compile) {
      var alias, buffer, compiled, file, files, output, source, _i, _len;
      files = FsUtil.find(this.APP_FOLDER, /.jade$/);
      output = "(function() {\n	__t('app').templates = { ~TEMPLATES };\n}).call( this );";
      buffer = [];
      for (_i = 0, _len = files.length; _i < _len; _i++) {
        file = files[_i];
        if (file.match(/(\_)?[^\/]+$/)[1] === "_") {
          continue;
        }
        alias = file.match(/views\/[^\.]+/);
        source = fs.readFileSync(file, "utf-8");
        compiled = jade.compile(source, {
          filename: file,
          client: true,
          compileDebug: false
        });
        compiled = compiled.toString().replace("anonymous", "");
        buffer.push(("'" + alias + "': ") + compiled);
      }
      output = output.replace("~TEMPLATES", buffer.join(","));
      output = this.to_single_line(output);
      return "// TEMPLATES\n" + output;
    };

    Compiler.prototype.compile_stylus = function(after_compile) {
      var buffer, file, files, paths, source, _i, _j, _len, _len1, _results,
        _this = this;
      files = FsUtil.find(this.APP_FOLDER, /.styl$/);
      buffer = [];
      this.pending_stylus = 0;
      for (_i = 0, _len = files.length; _i < _len; _i++) {
        file = files[_i];
        if (file.match(/(\_)?[^\/]+$/)[1] !== "_") {
          this.pending_stylus++;
        }
      }
      _results = [];
      for (_j = 0, _len1 = files.length; _j < _len1; _j++) {
        file = files[_j];
        if (file.match(/(\_)?[^\/]+$/)[1] === "_") {
          continue;
        }
        source = fs.readFileSync(file, "utf-8");
        paths = ["" + this.the.pwd + "/app/views/_mixins/stylus"];
        _results.push(stylus(source).set('filename', file).set('paths', paths).render(function(err, css) {
          if (err != null) {
            throw err;
          }
          buffer.push(css);
          if (--_this.pending_stylus === 0) {
            return after_compile(buffer.join("\n"));
          }
        }));
      }
      return _results;
    };

    Compiler.prototype.compile = function() {
      var conf, footer, header, templates,
        _this = this;
      conf = this._get_config();
      templates = this.compile_jade();
      header = "" + templates + "\n\n" + conf.config + "\n\n" + conf.routes + "\n\n" + conf.root + "\n";
      footer = "new theoricus.Theoricus";
      this.toaster.build(header, footer);
      return this.compile_stylus(function(css) {
        var target;
        target = "" + _this.the.pwd + "/public/app.css";
        return fs.writeFileSync(target, css);
      });
    };

    Compiler.prototype._get_config = function() {
      var app, routes;
      app = "" + this.the.pwd + "/config/app.coffee";
      routes = "" + this.the.pwd + "/config/routes.coffee";
      app = fs.readFileSync(app, "utf-8");
      routes = fs.readFileSync(routes, "utf-8");
      return new theoricus.commands.Config(app, routes);
    };

    Compiler.prototype.to_single_line = function(code) {
      return theoricus.commands.Compiler.to_single_line(code);
    };

    Compiler.to_single_line = function(code, ugli) {
      return code.replace(/(^\/\/.*)|([\t\n]+)/gm, "");
    };

    return Compiler;

  })();

  __t('theoricus.commands', exports).Config = (function() {
    var Compiler, cs, fs;

    Config.name = 'Config';

    Compiler = theoricus.commands.Compiler;

    fs = require("fs");

    cs = require("coffee-script");

    Config.prototype.config = null;

    Config.prototype.routes = null;

    Config.prototype.root = null;

    function Config(app, routes) {
      this._parse_app(app);
      this._parse_routes(routes);
    }

    Config.prototype._parse_app = function(app) {
      var tmp;
      try {
        tmp = {};
        app = cs.compile(app.replace(/(^\w)/gm, "tmp.$1"), {
          bare: 1
        });
        eval(app);
      } catch (error) {
        throw error;
      }
      return this.config = "// CONFIG\n" + Compiler.to_single_line("(function() {\n	__t('app').config = {\n		animate_at_startup: " + tmp.animate_at_startup + ",\n		enable_auto_transitions: " + tmp.enable_auto_transitions + "\n	};\n}).call( this );");
    };

    Config.prototype._parse_routes = function(routes) {
      var buffer, root, tmp;
      buffer = [];
      root = null;
      try {
        tmp = {
          root: function(route) {
            return root = route;
          },
          match: function(route, options) {
            route = "'" + route + "': {\n	to: '" + options.to + "',\n	at: '" + options.at + "',\n	el: '" + options.el + "'\n}";
            return buffer.push(route.replace("'null'", null));
          }
        };
        routes = cs.compile(routes.replace(/(^\w)/gm, "tmp.$1"), {
          bare: 1
        });
        eval(routes);
      } catch (error) {
        throw error;
      }
      this.root = "// ROOT\n" + Compiler.to_single_line("(function() {\n	__t('app').root = '" + root + "';\n\n}).call( this );", true);
      return this.routes = "// ROUTES\n" + Compiler.to_single_line("(function() {\n	__t('app').routes = {\n		" + (buffer.join(",")) + "\n	};\n}).call( this );", true);
    };

    return Config;

  })();

  __t('theoricus.commands', exports).Rm = (function() {
    var FsUtil, fs, path;

    Rm.name = 'Rm';

    fs = require('fs');

    path = require('path');

    FsUtil = require("coffee-toaster").FsUtil;

    function Rm(the, opts) {
      var action, name;
      this.the = the;
      action = opts[1];
      name = opts[2];
      switch (action) {
        case "controller":
          this.rm("app/controllers/" + name + "_controller.coffee");
          break;
        case "model":
          this.rm("app/models/" + name + "_model.coffee");
          break;
        case "view":
          this.rm("app/views/" + name + "_view.coffee");
          break;
        case "mvc":
          this.rm("app/controllers/" + name + "_controller.coffee");
          this.rm("app/models/" + name + "_model.coffee");
          this.rm(null, "app/views/" + name);
          break;
        default:
          console.log("ERROR: Valid options: controller,model,view,mvc.");
      }
    }

    Rm.prototype.rm = function(filepath, folderpath) {
      var target;
      if (path.existsSync((target = filepath || folderpath))) {
        try {
          if (filepath != null) {
            fs.unlinkSync(filepath);
          } else if (folderpath != null) {
            FsUtil.rmdir_rf(folderpath);
          }
        } catch (err) {
          throw err;
        }
        return console.log(("" + 'Removed:'.bold + " " + target).green);
      } else {
        return console.log(("Not found: " + filepath).yellow);
      }
    };

    return Rm;

  })();

  __t('theoricus.commands', exports).Server = (function() {
    var exec, fs, http, path, url;

    Server.name = 'Server';

    http = require("http");

    url = require("url");

    path = require("path");

    fs = require("fs");

    exec = require("child_process").exec;

    function Server(the, options) {
      this.the = the;
      this.port = "11235";
      this.root = "" + this.the.pwd + "/public";
      this.compiler = new theoricus.commands.Compiler(this.the, options);
      this.start_server();
    }

    Server.prototype.start_server = function() {
      var server,
        _this = this;
      server = function(request, response) {
        var agent, crawl, filename, headers, uri;
        headers = request.headers;
        agent = headers['user-agent'];
        crawl = agent.indexOf("Googlebot") >= 0 || agent.indexOf("curl") >= 0;
        uri = url.parse(request.url).pathname;
        filename = path.join(_this.root, uri);
        return path.exists(filename, function(exists) {
          var cmd, file, script;
          if (!exists || fs.lstatSync(filename).isDirectory()) {
            filename = path.join(_this.root, "/index.html");
            file = fs.readFileSync(filename, "utf-8");
            response.writeHead(200, {
              "Content-Type": "text/html"
            });
            if (crawl === true) {
              script = "" + _this.the.root + "/crawler/phantomjs.coffee";
              cmd = ("phantomjs " + script + " http://") + headers.host + request.url + "?crawler";
              exec(cmd, function(error, stdout, stderr) {
                if (error) {
                  throw error;
                }
                response.writeHead(200, {
                  "Content-Type": "text/html"
                });
                response.write(stdout);
                return response.end();
              });
            } else {
              response.write(file);
              response.end();
            }
            return;
          }
          return fs.readFile(filename, "utf-8", function(err, file) {
            if (err) {
              response.writeHead(500, {
                "Content-Type": "text/plain"
              });
              response.write(err + "\n");
              response.end();
              return;
            }
            if (filename.match(/.js$/m)) {
              response.writeHead(200, {
                "Content-Type": "text/javascript"
              });
            } else if (filename.match(/.css$/m)) {
              response.writeHead(200, {
                "Content-Type": "text/css"
              });
            }
            response.write(file);
            return response.end();
          });
        });
      };
      http.createServer(server).listen(this.port);
      return console.log(("" + 'Server running at'.bold + " http://localhost:" + this.port).grey);
    };

    return Server;

  })();

  __t('theoricus.generators', exports).Controller = (function() {
    var StringUtil, fs, template;

    Controller.name = 'Controller';

    fs = require('fs');

    StringUtil = require('coffee-toaster').StringUtil;

    template = {
      body: "class ~NAMEController extends app.controllers.AppController"
    };

    function Controller(the, opts) {
      var contents, filepath, name;
      this.the = the;
      name = opts[2];
      filepath = "app/controllers/" + name + "_controller.coffee";
      contents = this.build_contents(name);
      fs.writeFileSync(filepath, contents);
      console.log(("" + 'Created: '.bold + " " + filepath).green);
    }

    Controller.prototype.build_contents = function(name) {
      var buffer;
      buffer = "";
      return buffer += template.body.replace("~NAME", StringUtil.ucasef(name));
    };

    return Controller;

  })();

  __t('theoricus.generators', exports).Model = (function() {
    var StringUtil, fs, template;

    Model.name = 'Model';

    fs = require('fs');

    StringUtil = require('coffee-toaster').StringUtil;

    template = {
      body: "class ~NAMEModel extends app.models.AppModel"
    };

    function Model(the, opts) {
      var contents, filepath, name;
      this.the = the;
      name = opts[2];
      filepath = "app/models/" + name + "_model.coffee";
      contents = this.build_contents(name);
      fs.writeFileSync(filepath, contents);
      console.log(("" + 'Created: '.bold + " " + filepath).green);
    }

    Model.prototype.build_contents = function(name) {
      var buffer;
      buffer = "";
      return buffer += template.body.replace("~NAME", StringUtil.ucasef(name));
    };

    return Model;

  })();

  __t('theoricus.generators', exports).View = (function() {
    var FsUtil, StringUtil, Toaster, fs, template;

    View.name = 'View';

    fs = require('fs');

    FsUtil = require('coffee-toaster').FsUtil;

    StringUtil = require('coffee-toaster').StringUtil;

    Toaster = require('coffee-toaster').Toaster;

    template = {
      body: "class ~NAMEView extends app.views.AppView"
    };

    function View(the, opts) {
      var folderpath, jade, name, styl, view;
      this.the = the;
      name = opts[2];
      folderpath = "app/views/" + name;
      view = "" + folderpath + "/index_view.coffee";
      FsUtil.mkdir_p(folderpath = "" + folderpath + "/index");
      jade = "" + folderpath + "/index.jade";
      styl = "" + folderpath + "/index.styl";
      fs.writeFileSync(view, this.build_contents("index"));
      console.log(("" + 'Created: '.bold + " " + view).green);
      fs.writeFileSync(jade, "// put your templates (JADE) here ");
      console.log(("" + 'Created: '.bold + " " + jade).green);
      fs.writeFileSync(styl, "// put your styles (STYLUS) here");
      console.log(("" + 'Created: '.bold + " " + styl).green);
    }

    View.prototype.build_contents = function(name) {
      return template.body.replace("~NAME", StringUtil.ucasef(name));
    };

    return View;

  })();

  exports.run = function() {
    return new theoricus.Theoricus;
  };

  __t('theoricus', exports).Theoricus = (function() {
    var colors, fs, path;

    Theoricus.name = 'Theoricus';

    fs = require("fs");

    path = require("path");

    colors = require('colors');

    function Theoricus() {
      var cmd, cmds, options;
      this.pwd = this._get_app_root();
      this.root = path.normalize(__dirname + "/..");
      cmds = ("" + 'model'.cyan + '|'.white + 'view'.cyan + '|'.white) + ("" + 'controller'.cyan + '|'.white + 'all'.cyan);
      this.header = "" + 'Theoricus'.bold + " " + 'v0.0.1\n  Blast MVC implementation for CoffeeScript'.grey + "\n\n";
      this.header += "" + 'Usage:'.bold + "\n";
      this.header += "  theoricus " + 'new'.red + "      " + 'path'.green + "\n";
      this.header += "  theoricus " + 'add'.red + "      " + cmds + " [" + 'name'.magenta + "] [" + 'field1'.yellow + "] [" + 'field2'.yellow + "]\n";
      this.header += "  theoricus " + 'rm'.red + "       " + cmds + " [" + 'name'.magenta + "]\n";
      this.header += "  theoricus " + 'start'.red + "    [" + 'port'.magenta + "] [" + '--no-indexing'.green + "] [" + '--force-indexing'.green + "] [" + '--debug'.green + "] [" + '--env'.green + " " + 'production'.cyan + '|'.white + 'test'.cyan + '|'.white + 'development'.cyan + "]\n";
      this.header += "  theoricus " + 'compile'.red + "  [" + '--no-indexing'.green + "] [" + '--force-indexing'.green + "]\n";
      this.header += "  theoricus " + 'release'.red + "  [" + '--no-indexing'.green + "] [" + '--force-indexing'.green + "]\n\n";
      this.header += "" + 'Options:'.bold + "\n";
      this.header += "             " + 'new'.red + "   Creates a new working project in the file system.\n";
      this.header += "             " + 'add'.red + "   Generates a new model|view|controller file.\n";
      this.header += "              " + 'rm'.red + "   Destroy some model|view|controller file.\n";
      this.header += "           " + 'start'.red + "   Starts app in watch'n'compile mode at http://localhost:1123\n";
      this.header += "         " + 'compile'.red + "   Compile app to release destination.\n";
      this.header += "         " + 'version'.red + "   Show theoricus version.\n";
      this.header += "            " + 'help'.red + "   Show this help screen.\n\n";
      this.header += "" + 'Flags:'.bold + "\n";
      this.header += "         " + '--debug'.green + "   Use with 'start' to force debug mode in production or test environment   [default: false]\n";
      this.header += "           " + '--env'.green + "   Use with 'start' to set environment.                                     [default: dev  ]\n";
      this.header += " " + '--skip-indexing'.green + "   Use with 'start' or 'compile' to avoid static file's indexing.           [default: false]\n";
      this.header += "" + '--force-indexing'.green + "   Use with 'start' or 'compile' to force static file's indexing.           [default: false]\n\n";
      this.header += "" + 'Params:'.bold + "\n";
      this.header += "            " + 'name'.magenta + "   Name for your model, view and controller.\n";
      this.header += "          " + 'fields'.yellow + "   Model fields, can be used   when add new models or 'all'.\n";
      this.header += "         " + 'options'.yellow + "   Model fields, can be used   when add new models or 'all'.\n";
      options = process.argv.slice(2);
      cmd = options.join(" ").match(/([a-z]+)/);
      if (cmd != null) {
        cmd = cmd[1];
      }
      if (this.pwd === null && cmd === !"help") {
        console.log(("" + 'Error:'.bold + " Not a Theoricus app.").red);
        return;
      }
      switch (cmd) {
        case "new":
          new theoricus.commands.AddProject(this, options);
          break;
        case "add":
          new theoricus.commands.Add(this, options);
          break;
        case "rm":
          new theoricus.commands.Rm(this, options);
          break;
        case "start":
          new theoricus.commands.Server(this, options);
          break;
        case "compile":
          new theoricus.commands.Compiler(this, options);
          break;
        case "version":
          console.log("vesion");
          break;
        default:
          console.log(this.header);
      }
    }

    Theoricus.prototype._get_app_root = function() {
      var app, contents, current, tmp;
      current = path.resolve(".");
      while (true) {
        app = path.normalize("" + current + "/app/controllers/app_controller.coffee");
        if (!path.existsSync(app)) {
          tmp = path.normalize(path.resolve("" + current + "/../"));
          if (current === tmp) {
            return null;
          } else {
            current = tmp;
          }
        }
        contents = fs.readFileSync(app, "utf-8");
        if (contents.indexOf("theoricus.mvc.Controller") > 0) {
          return current;
        }
        return null;
      }
    };

    return Theoricus;

  })();

}).call(this);


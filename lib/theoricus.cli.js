
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

var theoricus = exports.theoricus = {};


(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  __t('theoricus.commands').Server = (function() {
    var exec, fs, http, path, url;

    http = require("http");

    url = require("url");

    path = require("path");

    fs = require("fs");

    exec = require("child_process").exec;

    function Server(the, options) {
      this.the = the;
      this._handler = __bind(this._handler, this);

      this.port = "11235";
      this.root = "" + this.the.pwd + "/public";
      this.compiler = new theoricus.commands.Compiler(this.the, options);
      this.start_server();
    }

    Server.prototype.start_server = function() {
      this.server = http.createServer(this._handler).listen(this.port);
      return console.log(("" + 'Server running at'.bold + " http://localhost:" + this.port).grey);
    };

    Server.prototype.close_server = function() {
      return this.server.close();
    };

    Server.prototype._handler = function(request, response) {
      var agent, crawl, filename, headers, uri,
        _this = this;
      headers = request.headers;
      agent = headers['user-agent'];
      crawl = agent.indexOf("Googlebot") >= 0 || agent.indexOf("curl") >= 0;
      uri = url.parse(request.url).pathname;
      filename = path.join(this.root, uri);
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

    return Server;

  })();

  __t('theoricus.crawler').Crawler = (function() {
    var phantom;

    phantom = require("phantom");

    Crawler.prototype.page = null;

    function Crawler(after_init) {
      var _this = this;
      phantom.create(function(ph) {
        return ph.createPage(function(page) {
          _this.page = page;
          return typeof after_init === "function" ? after_init() : void 0;
        });
      });
    }

    Crawler.prototype.get_src = function(url, on_get_source) {
      var _this = this;
      return this.page.open(url, function() {
        return _this.keep_on_checking(on_get_source);
      });
    };

    Crawler.prototype.keep_on_checking = function(on_get_source) {
      var _this = this;
      return this.page.evaluate((function() {
        return [window.crawler.is_rendered, document.all[0].outerHTML];
      }), function(data) {
        var rendered, source;
        rendered = data[0], source = data[1];
        if (rendered) {
          return on_get_source(source);
        }
        return setTimeout((function() {
          return _this.keep_on_checking(on_get_source);
        }), 10);
      });
    };

    return Crawler;

  })();

  __t('theoricus.commands').Add = (function() {

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

  __t('theoricus.commands').AddProject = (function() {
    var exec, path, pn;

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
      this.app_skel = pn("" + this.root + "/cli/src/generators/templates/app_skel");
      this.target = pn("" + this.pwd + "/" + this.options[1]);
      if (path.existsSync(this.target)) {
        console.log("ERROR".bold.red + " Target directory already existis." + ("\n\t" + this.target).yellow);
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

  __t('theoricus.commands').Compiler = (function() {
    var ArrayUtil, FsUtil, Toaster, fs, jade, path, stylus;

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
        vendors: ["" + this.the.root + "/www/vendors/jquery.js", "" + this.the.root + "/www/vendors/history.js", "" + this.the.root + "/www/vendors/history.adapter.native.js", "" + this.the.root + "/www/vendors/jade.runtime.js"],
        release: "public/app.js",
        debug: "public/app-debug.js"
      };
      config.folders[this.APP_FOLDER] = "app";
      config.folders["" + this.the.root + "/www/src"] = "theoricus";
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

  __t('theoricus.commands').Config = (function() {
    var Compiler, cs, fs;

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

  __t('theoricus.commands').Index = (function() {
    var FsUtil, exec, fs, path;

    fs = require("fs");

    exec = (require("child_process")).exec;

    path = require("path");

    FsUtil = (require("coffee-toaster")).toaster.utils.FsUtil;

    Index.prototype.pages = {};

    function Index(the, options) {
      var _this = this;
      this.the = the;
      this.options = options;
      exec("phantomjs -v", function(error, stdout, stderr) {
        if (/phantomjs: command not found/.test(stderr)) {
          return console.log("Error ".bold.red + ("Install " + 'phantomjs'.yellow) + " before indexing pages." + "\n\thttp://phantomjs.org/");
        } else {
          _this.server = new theoricus.commands.Server(_this.the, _this.options);
          console.log("Start indexing...".bold.green);
          return _this.crawler = new theoricus.crawler.Crawler(function() {
            return _this.get_page("http://localhost:11235/");
          });
        }
      });
    }

    Index.prototype.get_page = function(url) {
      var _this = this;
      return this.crawler.get_src(url, function(src) {
        var crawled, from, to, _ref;
        _this.get_links(url, src);
        _this.save_page(url, src);
        _this.pages[url] = true;
        _ref = _this.pages;
        for (url in _ref) {
          crawled = _ref[url];
          if (!crawled) {
            return _this.get_page(url);
          }
        }
        from = "" + _this.the.pwd + "/public";
        to = "" + _this.the.pwd + "/public/static";
        fs.writeFileSync("" + to + "/app.js", "");
        src = fs.readFileSync("" + from + "/app.css", "utf-8");
        fs.writeFileSync("" + to + "/app.css", src);
        console.log("Pages indexed successfully.".bold.green);
        _this.server.close_server();
        return _this.static_server = new theoricus.commands.StaticServer(_this.the, _this.options);
      });
    };

    Index.prototype.get_links = function(url, src) {
      var domain, matched, reg, _results;
      domain = url.match(/(http:\/\/[\w]+:?[0-9]*)/g);
      reg = /a\shref=(\"|\')(\/)?([^\'\"]+)/g;
      _results = [];
      while ((matched = reg.exec(src)) != null) {
        url = "" + domain + "/" + matched[3];
        if (this.pages[url] !== true) {
          _results.push(this.pages[url] = false);
        } else {
          _results.push(void 0);
        }
      }
      return _results;
    };

    Index.prototype.save_page = function(url, src) {
      var file, folder, route;
      route = (/(http:\/\/)([\w]+)(:)?([0-9]+)?\/(.*)/g.exec(url))[5];
      folder = path.normalize("" + this.the.pwd + "/public/static/" + route);
      if (!path.existsSync(folder)) {
        FsUtil.mkdir_p(folder);
      }
      fs.writeFileSync((file = path.normalize("" + folder + "/index.html")), src);
      route = (route || "/").bold.yellow;
      return console.log("\t" + route.bold.yellow + " -> " + file);
    };

    return Index;

  })();

  __t('theoricus.commands').Rm = (function() {
    var FsUtil, fs, path;

    fs = require('fs');

    path = require('path');

    FsUtil = (require('coffee-toaster')).toaster.utils.FsUtil;

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

  __t('theoricus.commands').StaticServer = (function() {
    var HTTPServer;

    HTTPServer = require("http-server");

    function StaticServer(the, options) {
      var server,
        _this = this;
      this.the = the;
      this.port = "11235";
      this.root = "" + this.the.pwd + "/public/static";
      server = HTTPServer.createServer({
        root: this.root,
        port: this.port,
        autoIndex: true
      });
      server.listen(this.port, "0.0.0.0", function() {
        var msg;
        msg = ("" + 'Static server running at'.bold + " http://localhost:" + _this.port).grey;
        return console.log(msg);
      });
    }

    return StaticServer;

  })();

  __t('theoricus.generators').Controller = (function() {
    var StringUtil, fs, template;

    fs = require('fs');

    StringUtil = (require('coffee-toaster')).toaster.utils.StringUtil;

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

  __t('theoricus.generators').Model = (function() {
    var StringUtil, fs, template;

    fs = require('fs');

    StringUtil = (require('coffee-toaster')).toaster.utils.StringUtil;

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

  __t('theoricus.generators').View = (function() {
    var FsUtil, StringUtil, Toaster, fs, template;

    fs = require('fs');

    FsUtil = (require('coffee-toaster')).toaster.utils.FsUtil;

    StringUtil = (require('coffee-toaster')).toaster.utils.StringUtil;

    Toaster = (require('coffee-toaster')).Toaster;

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

  __t('theoricus').Theoricus = (function() {
    var colors, fs, path;

    fs = require("fs");

    path = require("path");

    colors = require('colors');

    function Theoricus() {
      var cmd, cmds, options;
      cmds = ("" + 'model'.cyan + '|'.white + 'view'.cyan + '|'.white) + ("" + 'controller'.cyan + '|'.white + 'all'.cyan);
      this.header = "" + 'Theoricus'.bold + " " + 'v0.1.0\n  Blast navigable-MVC implementation for the browser.'.grey + "\n\n";
      this.header += "" + 'Usage:'.bold + "\n";
      this.header += "  theoricus " + 'new'.red + "      " + 'path'.green + "\n";
      this.header += "  theoricus " + 'add'.red + "      " + cmds + " \n";
      this.header += "  theoricus " + 'rm'.red + "       " + cmds + " \n";
      this.header += "  theoricus " + 'start'.red + "    \n";
      this.header += "  theoricus " + 'compile'.red + "  \n";
      this.header += "  theoricus " + 'index'.red + "    \n\n";
      this.header += "" + 'Options:'.bold + "\n";
      this.header += "             " + 'new'.red + "   Creates a new working project in the file system.\n";
      this.header += "             " + 'add'.red + "   Generates a new model|view|controller file.\n";
      this.header += "              " + 'rm'.red + "   Destroy some model|view|controller file.\n";
      this.header += "           " + 'start'.red + "   Starts app in watch'n'compile mode at http://localhost:1123\n";
      this.header += "         " + 'compile'.red + "   Compile app to release destination.\n";
      this.header += "           " + 'index'.red + "   Index the whole application to a static non-js version.\n";
      this.header += "         " + 'version'.red + "   Show theoricus version.\n";
      this.header += "            " + 'help'.red + "   Show this help screen.\n";
      options = process.argv.slice(2);
      cmd = options.join(" ").match(/([a-z]+)/);
      if (cmd != null) {
        cmd = cmd[1];
      }
      this.root = path.normalize(__dirname + "/..");
      this.app_root = this._get_app_root();
      this.pwd = this.app_root || path.resolve(".");
      if (this.app_root === null && cmd !== "help" && cmd !== "new") {
        console.log("ERROR".bold.red + " Not a Theoricus app.");
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
        case "static":
          new theoricus.commands.StaticServer(this, options);
          break;
        case "compile":
          new theoricus.commands.Compiler(this, options);
          break;
        case "index":
          new theoricus.commands.Index(this, options);
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
        if (path.existsSync(app)) {
          contents = fs.readFileSync(app, "utf-8");
          if (contents.indexOf("theoricus.mvc.Controller") > 0) {
            return current;
          } else {
            return null;
          }
        } else {
          tmp = path.normalize(path.resolve("" + current + "/../"));
          if (current === tmp) {
            return null;
          } else {
            current = tmp;
            continue;
          }
        }
      }
    };

    return Theoricus;

  })();

}).call(this);


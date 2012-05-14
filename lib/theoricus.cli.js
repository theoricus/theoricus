
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

var theoricus = {};

(function() {

  __t('theoricus.commands').Add = (function() {

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

  __t('theoricus.commands').AddProject = (function() {
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

  __t('theoricus.commands').Compiler = (function() {

    Compiler.name = 'Compiler';

    function Compiler() {}

    return Compiler;

  })();

  __t('theoricus.commands').Rm = (function() {
    var fs, path;

    Rm.name = 'Rm';

    fs = require('fs');

    path = require('path');

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
          this.rm("app/views/" + name + "_view.coffee");
          this.rm("app/views/" + name + "_view.styl");
          this.rm("app/views/" + name + "_view.jade");
          break;
        default:
          console.log("ERROR: Valid options: controller,model,view,mvc.");
      }
    }

    Rm.prototype.rm = function(filepath) {
      if (path.existsSync(filepath)) {
        fs.unlinkSync(filepath);
        return console.log(("" + 'Removed:'.bold + " " + filepath).green);
      } else {
        return console.log(("Not found: " + filepath).yellow);
      }
    };

    return Rm;

  })();

  __t('theoricus.commands').Server = (function() {

    Server.name = 'Server';

    function Server() {}

    return Server;

  })();

  __t('theoricus.generators').Controller = (function() {
    var fs, template;

    Controller.name = 'Controller';

    fs = require('fs');

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
      return buffer += template.body.replace("~NAME", name);
    };

    return Controller;

  })();

  __t('theoricus.generators').Model = (function() {
    var fs, template;

    Model.name = 'Model';

    fs = require('fs');

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
      return buffer += template.body.replace("~NAME", name);
    };

    return Model;

  })();

  __t('theoricus.generators').View = (function() {
    var fs, template;

    View.name = 'View';

    fs = require('fs');

    template = {
      body: "class ~NAMEView extends app.views.AppView"
    };

    function View(the, opts) {
      var contents, filepath, name;
      this.the = the;
      name = opts[2];
      filepath = "app/views/" + name + "_view.coffee";
      contents = this.build_contents(name);
      fs.writeFileSync(filepath, contents);
      console.log(("" + 'Created: '.bold + " " + filepath).green);
      filepath = filepath.replace(".coffee", ".styl");
      fs.writeFileSync(filepath, "// put your styles (stylus) here ");
      console.log(("" + 'Created: '.bold + " " + filepath).green);
      filepath = filepath.replace(".styl", ".jade");
      fs.writeFileSync(filepath, "// put your tempalte(jade) here");
      console.log(("" + 'Created: '.bold + " " + filepath).green);
    }

    View.prototype.build_contents = function(name) {
      var buffer;
      buffer = "";
      return buffer += template.body.replace("~NAME", name);
    };

    return View;

  })();

  exports.run = function() {
    return new theoricus.Theoricus;
  };

  __t('theoricus').Theoricus = (function() {
    var colors, path;

    Theoricus.name = 'Theoricus';

    path = require("path");

    colors = require('colors');

    function Theoricus() {
      var cmd, cmds, options;
      this.pwd = path.resolve(".");
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

    return Theoricus;

  })();

}).call(this);

(function() {

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

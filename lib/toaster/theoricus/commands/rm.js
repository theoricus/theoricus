(function() {

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

}).call(this);

(function() {

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

}).call(this);

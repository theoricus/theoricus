(function() {

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

}).call(this);

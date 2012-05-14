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

}).call(this);

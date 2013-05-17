(function() {

  theoricus.Theoricus = (function() {

    Theoricus.prototype.app = null;

    Theoricus.prototype.base_path = '';

    Theoricus.prototype.root = null;

    Theoricus.prototype.factory = null;

    Theoricus.prototype.config = null;

    Theoricus.prototype.processes = null;

    Theoricus.prototype.crawler = (window.crawler = {
      is_rendered: false
    });

    function Theoricus() {
      this.config = new theoricus.config.Config(this);
      this.factory = new theoricus.core.Factory(this);
    }

    Theoricus.prototype.start = function() {
      return this.processes = new theoricus.core.Processes(this);
    };

    return Theoricus;

  })();

}).call(this);

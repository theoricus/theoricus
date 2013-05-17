(function() {

  theoricus.mvc.lib.Fetcher = (function() {

    function Fetcher() {}

    Fetcher.prototype.loaded = null;

    Fetcher.prototype.onload = null;

    Fetcher.prototype.onerror = null;

    Fetcher.prototype.data = null;

    return Fetcher;

  })();

}).call(this);

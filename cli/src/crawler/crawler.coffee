class theoricus.crawler.Crawler

  phantom = require "node-phantom"
  page: null

  constructor:( after_init )->
    phantom.create (error, @ph) =>
      @ph.createPage (error, @page) =>
        after_init?()

  get_src:( url, on_get_source )->
    @page.open url, =>
      @keep_on_checking on_get_source

  keep_on_checking:( on_get_source )->
    @page.evaluate (-> [
      window.crawler.is_rendered,
      document.all[0].outerHTML
    ]), ( error, data )=>
      [rendered, source] = data
      return (on_get_source source) if rendered
      setTimeout (=> @keep_on_checking on_get_source), 10

  exit:->
    @ph.exit()
class theoricus.crawler.Crawler

  phantom = require "phantom"
  page: null

  constructor:( after_init )->
    phantom.create (@ph) => @ph.createPage (@page) => after_init?()

  get_src:( url, on_get_source )->
    @page.open url, => @keep_on_checking on_get_source

  keep_on_checking:( on_get_source )->
    @page.evaluate (-> [
      window.crawler.is_rendered,
      document.all[0].outerHTML
    ]), ( data )=>
      [rendered, source] = data
      return (on_get_source source) if rendered
      setTimeout (=> @keep_on_checking on_get_source), 10

  exit:->
    @ph.exit()
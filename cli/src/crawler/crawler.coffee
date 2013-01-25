class theoricus.crawler.Crawler

  phantom = require "node-phantom"

  page: null

  get_url:( url, done )->

    @ph.exit() if @ph?

    @ph   = null
    @page = null


    phantom.create (error, @ph) =>
      @ph.createPage (error, @page) =>
        @page.open url, (err, status )=>

          if status is not 'ok'

            return done( null )

          @keep_on_checking url, done

  keep_on_checking:( url, done )->

    @page.evaluate ( -> 
      data =
        rendered: window.crawler.is_rendered
        source  : document.all[0].outerHTML
    ), ( error, data ) =>

      # sometimes data is null, perhaps when the page is 404
      # but to be honest, not sure when
      if data is null

        return done null

      if data.rendered

        return done data.source

      setTimeout (=> @keep_on_checking url, done), 10

  exit: ->
    @ph.exit()
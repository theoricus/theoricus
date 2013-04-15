class Refresh

	constructor: ->

    socket = io.connect "http://localhost"

    socket.on "refresh", (data) ->

      if data.js? then return location.reload()

      if data.style

        $( 'link' ).each ( index, item ) ->

          url = ( $( item ).attr 'href' ).split( '?' )[0]

          $( item ).attr 'href', url + "?#{Math.random()}"

new Refresh()
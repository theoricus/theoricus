View = require 'theoricus/mvc/view'

exports.module = class AppView extends View

  set_triggers: ->
		super()

		# automagically route links starting with "/"
		$( 'a[href*="/"]' ).each ( index, item ) =>
			$( item ).click ( event ) =>
				@navigate $( event.target ).attr 'href'

				return off

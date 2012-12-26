class theoricus.mvc.lib.Binder

	# some regexes used to catch binds injected by theoricus's compiler

	# match any bind
	context_reg = '(<!-- @[\\w]+ -->)([^<]+)(<!-- \/@[\\w]+ -->)'

	# template for matching one specific bind
	bind_reg = "(<!-- @~KEY -->)([^<]+)(<!-- \/@~KEY -->)"

	# match the bind's variable name
	bind_name_reg = /(<!-- @)([\w]+)( -->)/

	# container for all found binds
	binds: null


	constructor:->
		@binds = {}

	bind:( dom )->
		@binds = (parse dom)

	update:( field, val )->

		return if @binds[field] is null

		for item in (@binds[field] || [])
			
			node = ($ item.target)
			switch item.type
				when 'node'
					current = node.html()
					search = new RegExp (bind_reg.replace /\~KEY/g, field), 'g'
					updated = current.replace search, "$1#{val}$3"
					node.html updated
					break

				when 'attr'
					node.attr item.attr, val

	parse = (dom, binds = {})->
		dom.children().each ->
			# searching for binds in node attributes
			for attr in this.attributes
				name = attr.nodeName
				value = attr.nodeValue

				# get attribute's binds
				match_single = new RegExp context_reg
				if match_single.test value
					key = (value.match bind_name_reg)[2]
					(($ this).attr name, (value.match match_single)[2])
					collect binds, this, 'attr', key, name

			# preparing node to start the search for binds
			match_all = new RegExp context_reg, 'g'
			text = ($ this ).clone().children().remove().end().html()
			text = "#{text}"

			# get all binds (multiple binds per node is allowed)
			keys = (text.match match_all) or []

			# collects all found binds for the node value
			for key in keys
				key = (key.match bind_name_reg)[2]
				collect binds, this, 'node', key

			

			# keep parsing the dom recursively
			parse ($ this), binds

		binds

	collect = (binds, target, type, variable, attr)->
		bind = (binds[variable] ?= [])
		tmp = type: type, target: target
		tmp.attr = attr if attr?
		bind.push tmp
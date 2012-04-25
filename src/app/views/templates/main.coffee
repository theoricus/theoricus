class MainTemplate
	dom:( data )->
		div "header", ->
			h1 "I'm the HEADER."
		
		div "main", ->
			h1 "I'm the MAIN."		
			p item for item in data.lines

		div "footer", ->
			h1 "I'm the FOOTER."
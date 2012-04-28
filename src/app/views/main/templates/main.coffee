class MainTemplate
	dom:( data )->
		div "header", ->
			h1 "I'm the HEADER."
			div "menu", ->
				p a href:"/main", "/main"
				p a href:"/home", "/home"
				p a href:"/features", "/features"
				p a href:"/feature/1", "/feature/1"
		
		div "main", ->
			h1 "I'm the MAIN."		
			p item for item in data.lines
			div id:"holder"

		div "footer", ->
			h1 "I'm the FOOTER."
class MainTemplate
	dom:( data )->
		div "header", ->
			h1 "I'm the HEADER."
			div "menu", ->
				p a href:"/main", "/main"
				p a href:"/main/home", "/main/home"
				p a href:"/main/home/features", "/main/home/features"
				p a href:"/main/home/features/1", "/main/home/features/1"
		
		div "main", ->
			h1 "I'm the MAIN."		
			p item for item in data.lines
			div id:"holder"

		div "footer", ->
			h1 "I'm the FOOTER."
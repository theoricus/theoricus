#<< theoricus/theoricus

class App extends theoricus.Theoricus
	constructor:->
		super
			# # Application locales
			locales:
				default: "en"
				all: ["en", "pt", "es"]

			# Boot / Root url (default route)
			boot: "/main"

			# Animates all levels on start up or just renders everything
			animate_at_startup: false

			# enables / disables auto fadein-fadeout as transitions
			auto_transitions: true

			# Application routes
			routes:
				"/main":
					to: "main/index",
					at: "body"

				"/home":
					to: "home/home",
					at: "/main#holder"

				"/features":
					to: "home/features",
					at: "/main#holder"

				"/feature/:feature_id":
					to: "home/show_feature",
					at: "/features#feature"

$( document ).ready ->
	new app.App
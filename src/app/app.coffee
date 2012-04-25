#<< theoricus/theoricus

class App extends theoricus.Theoricus
	constructor:->
		super
			# # Application locales
			locales:
				default: "en"
				all: ["en", "pt", "es"]

			# Boot / Root url (default route)
			boot: "/main/home"

			# Application routes
			routes:
				"/main":
					to: "main/index",
					at: "body"

				"/main/home":
					to: "home/index",
					at: "/main#holder"

				"/main/home/features":
					to: "home/features",
					at: "/main/home#features"

				"/main/home/feature/:feature_id/*genre":
					to: "home/show_feature",
					at: "/main/home/features#feature"

$( document ).ready ->
	new app.App
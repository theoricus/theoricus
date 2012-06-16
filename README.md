# Theoricus

Made to serve your needs and make you happy.

# Installation

npm install -g theoricus

# Scaffolding new app

````bash

theoricus new myawesomeapp
````

It'll produce the following structure:

	├── app
	│   ├── controllers
	│   │   ├── app_controller.coffee
	│   │   └── main_controller.coffee
	│   ├── models
	│   │   ├── app_model.coffee
	│   │   └── main_model.coffee
	│   └── views
	│       ├── _mixins
	│       │   ├── jade
	│       │   └── stylus
	│       │       └── global_mixins.styl
	│       ├── app_view.coffee
	│       └── main
	│           ├── index
	│           │   ├── index.jade
	│           │   └── index.styl
	│           └── index_view.coffee
	├── config
	│   ├── app.coffee
	│   └── routes.coffee
	├── public
	│   ├── app.css
	│   ├── app.js
	│   └── index.html
	└── vendors

# Testing

To test your fresh application, enter the project folder (cd myawesomeapp) and:

````javascript

theoricus start
````

Visit the url [http://localhost:11235](http://localhost:11235) and you should see a success status.
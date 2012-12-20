build:
	git submodule update --init

	toaster -c
	
	cp lib/theoricus.js cli/src/generators/templates/app_skel/vendors/

	npm link

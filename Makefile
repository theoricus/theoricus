build:
	git submodule update --init

	cp lib/theoricus.js cli/src/generators/templates/app_skel/vendors/

	toaster -c

	npm link

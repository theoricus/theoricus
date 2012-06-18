class Crawler

	call = (require "child_process").exec
	phantom = "#{__dirname}/../cli/theoricus/crawler/phantom.coffee"

	constructor:( url, on_src_evaluated )->
		call "phantomjs #{phantom} #{url}", (error, stdout, stderr)->
			throw error if error?
			on_src_evaluated?( stdout )
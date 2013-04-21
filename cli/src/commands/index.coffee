# fs = require "fs"
# exec = (require "child_process").exec
# path = require "path"
# fsu = require "fs-util"

# Crawler = require '../crawler/crawler'

# module.exports = class Index


#   #
#   # key -> value ( address -> is_crawled)
#   #
#   pages: {}

#   #
#   # the initial address to be crawled
#   #
#   url: null

#   #
#   # max number of connections
#   #
#   max_connections: 10

#   #
#   # current connections
#   #
#   connections: 0

#   #
#   #
#   #
#   crawlers: []

#   constructor:( @the, @options )->

#     @url = options[1] or "http://localhost:11235/"

#     exec "phantomjs -v", (error, stdout, stderr)=>

#       if /phantomjs: command not found/.test stderr

#         console.log "Error ".bold.red + "Install #{'phantomjs'.yellow}"+
#               " before indexing pages."+
#               "\n\thttp://phantomjs.org/"

#       else

#         console.log " - initializing..."

#         console.log " #{'>'.yellow} " + @url.grey
        
#         @get @url


#   get:( url )->

#     crawler = new Crawler()

#     @connections++

#     @crawlers.push crawler

#     @pages[url] = true

#     crawler.get_url url, ( src ) => 

#       @after_render( url, src )

#       crawler.exit()

#       crawler = null

#   after_render:(url, src)->

#     #
#     # IF source is null
#     #   - mark crawled and continue 
#     # ELSE
#     #   - get links and save pages
#     #
#     if src

#       @parse_links url, src

#       @save_page url, src

#     else

#       console.log " ? skipping, source is empty or null or some problem occured #{url}"

#     @connections--

#     # crawl next pages
#     for url, crawled of @pages

#       continue if @pages[url]

#       @get url

#       if @connections == @max_connections
#         break

#     @done() unless @connections > 0
      

#   ###
#   Parse Source code for giving URL indexing links to be cralwed 

#   @param url: String 
#   @param src: String
#   ###
#   parse_links:( url, src )->

#     domain = url.match /(http:\/\/[\w]+:?[0-9]*)/g
#     reg    = /a\shref=(\"|\')(\/)?([^\'\"]+)/g

#     console.log " - scanning links - #{url}"

#     while (matched = (reg.exec src))?

#       # skip if its external link
#       continue if /^http/m.test matched[3]

#       url = "#{domain}/#{matched[3]}"

#       # skip if it was already crawled
#       continue if @pages[url]

#       continue if url.indexOf( @url ) != 0

#       # skip if was already rendered
#       # if @has_rendered( url )
#       #   console.log " - skipping, already saved - #{url}"
#       #   continue

#       console.log " #{'+'.green} " + (url.replace( @url, '' ) ).grey

#       @pages[url] = false


#   save_page:( url, src )->

#     route = (/(http:\/\/)([\w]+)(:)?([0-9]+)?\/(.*)/g.exec url)[5]
#     folder = path.normalize "#{@the.pwd}/public/static/#{route}"
#     fsu.mkdir_p folder unless fs.existsSync( folder )

#     src = ((require 'pretty-data').pd.xml src) + "\n"

#     file = path.normalize "#{folder}/index.html"
#     fs.writeFileSync file, src
#     route = (route || "/").bold.yellow

#     console.log " ! rendered - #{route.bold.yellow} -> #{folder}"

#   #
#   # Simply check if a file was already rendered for this address
#   # skip if so.
#   #
#   has_rendered:( url )->
#     route  = (/(http:\/\/)([\w]+)(:)?([0-9]+)?\/(.*)/g.exec url)[5]
#     folder = path.normalize "#{@the.pwd}/public/static/#{route}"

#     return fs.existsSync( folder )

#   done: ->

#       from = "#{@the.pwd}/public"
#       to   = "#{@the.pwd}/public/static"
      
#       # src = fs.readFileSync "#{from}/app.js", "utf-8"
#       # fs.writeFileSync "#{to}/app.js", src
#       fs.writeFileSync "#{to}/app.js", ""

#       src = fs.readFileSync "#{from}/app.css", "utf-8"
#       fs.writeFileSync "#{to}/app.css", src

#       console.log " OK - indexed successfully.".bold.green
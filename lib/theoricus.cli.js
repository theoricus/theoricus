/*
Copyright (c) 2010 Ryan Schuft (ryan.schuft@gmail.com)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/

/*
  This code is based in part on the work done in Ruby to support
  infection as part of Ruby on Rails in the ActiveSupport's Inflector
  and Inflections classes.  It was initally ported to Javascript by
  Ryan Schuft (ryan.schuft@gmail.com) in 2007.

  The code is available at http://code.google.com/p/inflection-js/

  The basic usage is:
    1. Include this script on your web page.
    2. Call functions on any String object in Javascript

  Currently implemented functions:

    String.pluralize(plural) == String
      renders a singular English language noun into its plural form
      normal results can be overridden by passing in an alternative

    String.singularize(singular) == String
      renders a plural English language noun into its singular form
      normal results can be overridden by passing in an alterative

    String.camelize(lowFirstLetter) == String
      renders a lower case underscored word into camel case
      the first letter of the result will be upper case unless you pass true
      also translates "/" into "::" (underscore does the opposite)

    String.underscore() == String
      renders a camel cased word into words seperated by underscores
      also translates "::" back into "/" (camelize does the opposite)

    String.humanize(lowFirstLetter) == String
      renders a lower case and underscored word into human readable form
      defaults to making the first letter capitalized unless you pass true

    String.capitalize() == String
      renders all characters to lower case and then makes the first upper

    String.dasherize() == String
      renders all underbars and spaces as dashes

    String.titleize() == String
      renders words into title casing (as for book titles)

    String.demodulize() == String
      renders class names that are prepended by modules into just the class

    String.tableize() == String
      renders camel cased singular words into their underscored plural form

    String.classify() == String
      renders an underscored plural word into its camel cased singular form

    String.foreign_key(dropIdUbar) == String
      renders a class name (camel cased singular noun) into a foreign key
      defaults to seperating the class from the id with an underbar unless
      you pass true

    String.ordinalize() == String
      renders all numbers found in the string into their sequence like "22nd"
*/

/*
  This sets up a container for some constants in its own namespace
  We use the window (if available) to enable dynamic loading of this script
  Window won't necessarily exist for non-browsers.
*/
// if (window && !window.InflectionJS)
// {
//     window.InflectionJS = null;
// }

/*
  This sets up some constants for later use
  This should use the window namespace variable if available
*/
InflectionJS =
{
    /*
      This is a list of nouns that use the same form for both singular and plural.
      This list should remain entirely in lower case to correctly match Strings.
    */
    uncountable_words: [
        'equipment', 'information', 'rice', 'money', 'species', 'series',
        'fish', 'sheep', 'moose', 'deer', 'news'
    ],

    /*
      These rules translate from the singular form of a noun to its plural form.
    */
    plural_rules: [
        [new RegExp('(m)an$', 'gi'),                 '$1en'],
        [new RegExp('(pe)rson$', 'gi'),              '$1ople'],
        [new RegExp('(child)$', 'gi'),               '$1ren'],
        [new RegExp('^(ox)$', 'gi'),                 '$1en'],
        [new RegExp('(ax|test)is$', 'gi'),           '$1es'],
        [new RegExp('(octop|vir)us$', 'gi'),         '$1i'],
        [new RegExp('(alias|status)$', 'gi'),        '$1es'],
        [new RegExp('(bu)s$', 'gi'),                 '$1ses'],
        [new RegExp('(buffal|tomat|potat)o$', 'gi'), '$1oes'],
        [new RegExp('([ti])um$', 'gi'),              '$1a'],
        [new RegExp('sis$', 'gi'),                   'ses'],
        [new RegExp('(?:([^f])fe|([lr])f)$', 'gi'),  '$1$2ves'],
        [new RegExp('(hive)$', 'gi'),                '$1s'],
        [new RegExp('([^aeiouy]|qu)y$', 'gi'),       '$1ies'],
        [new RegExp('(x|ch|ss|sh)$', 'gi'),          '$1es'],
        [new RegExp('(matr|vert|ind)ix|ex$', 'gi'),  '$1ices'],
        [new RegExp('([m|l])ouse$', 'gi'),           '$1ice'],
        [new RegExp('(quiz)$', 'gi'),                '$1zes'],
        [new RegExp('s$', 'gi'),                     's'],
        [new RegExp('$', 'gi'),                      's']
    ],

    /*
      These rules translate from the plural form of a noun to its singular form.
    */
    singular_rules: [
        [new RegExp('(m)en$', 'gi'),                                                       '$1an'],
        [new RegExp('(pe)ople$', 'gi'),                                                    '$1rson'],
        [new RegExp('(child)ren$', 'gi'),                                                  '$1'],
        [new RegExp('([ti])a$', 'gi'),                                                     '$1um'],
        [new RegExp('((a)naly|(b)a|(d)iagno|(p)arenthe|(p)rogno|(s)ynop|(t)he)ses$','gi'), '$1$2sis'],
        [new RegExp('(hive)s$', 'gi'),                                                     '$1'],
        [new RegExp('(tive)s$', 'gi'),                                                     '$1'],
        [new RegExp('(curve)s$', 'gi'),                                                    '$1'],
        [new RegExp('([lr])ves$', 'gi'),                                                   '$1f'],
        [new RegExp('([^fo])ves$', 'gi'),                                                  '$1fe'],
        [new RegExp('([^aeiouy]|qu)ies$', 'gi'),                                           '$1y'],
        [new RegExp('(s)eries$', 'gi'),                                                    '$1eries'],
        [new RegExp('(m)ovies$', 'gi'),                                                    '$1ovie'],
        [new RegExp('(x|ch|ss|sh)es$', 'gi'),                                              '$1'],
        [new RegExp('([m|l])ice$', 'gi'),                                                  '$1ouse'],
        [new RegExp('(bus)es$', 'gi'),                                                     '$1'],
        [new RegExp('(o)es$', 'gi'),                                                       '$1'],
        [new RegExp('(shoe)s$', 'gi'),                                                     '$1'],
        [new RegExp('(cris|ax|test)es$', 'gi'),                                            '$1is'],
        [new RegExp('(octop|vir)i$', 'gi'),                                                '$1us'],
        [new RegExp('(alias|status)es$', 'gi'),                                            '$1'],
        [new RegExp('^(ox)en', 'gi'),                                                      '$1'],
        [new RegExp('(vert|ind)ices$', 'gi'),                                              '$1ex'],
        [new RegExp('(matr)ices$', 'gi'),                                                  '$1ix'],
        [new RegExp('(quiz)zes$', 'gi'),                                                   '$1'],
        [new RegExp('s$', 'gi'),                                                           '']
    ],

    /*
      This is a list of words that should not be capitalized for title case
    */
    non_titlecased_words: [
        'and', 'or', 'nor', 'a', 'an', 'the', 'so', 'but', 'to', 'of', 'at',
        'by', 'from', 'into', 'on', 'onto', 'off', 'out', 'in', 'over',
        'with', 'for'
    ],

    /*
      These are regular expressions used for converting between String formats
    */
    id_suffix: new RegExp('(_ids|_id)$', 'g'),
    underbar: new RegExp('_', 'g'),
    space_or_underbar: new RegExp('[\ _]', 'g'),
    uppercase: new RegExp('([A-Z])', 'g'),
    underbar_prefix: new RegExp('^_'),
    
    /*
      This is a helper method that applies rules based replacement to a String
      Signature:
        InflectionJS.apply_rules(str, rules, skip, override) == String
      Arguments:
        str - String - String to modify and return based on the passed rules
        rules - Array: [RegExp, String] - Regexp to match paired with String to use for replacement
        skip - Array: [String] - Strings to skip if they match
        override - String (optional) - String to return as though this method succeeded (used to conform to APIs)
      Returns:
        String - passed String modified by passed rules
      Examples:
        InflectionJS.apply_rules("cows", InflectionJs.singular_rules) === 'cow'
    */
    apply_rules: function(str, rules, skip, override)
    {
        if (override)
        {
            str = override;
        }
        else
        {
            var ignore = (skip.indexOf(str.toLowerCase()) > -1);
            if (!ignore)
            {
                for (var x = 0; x < rules.length; x++)
                {
                    if (str.match(rules[x][0]))
                    {
                        str = str.replace(rules[x][0], rules[x][1]);
                        break;
                    }
                }
            }
        }
        return str;
    }
};

/*
  This lets us detect if an Array contains a given element
  Signature:
    Array.indexOf(item, fromIndex, compareFunc) == Integer
  Arguments:
    item - Object - object to locate in the Array
    fromIndex - Integer (optional) - starts checking from this position in the Array
    compareFunc - Function (optional) - function used to compare Array item vs passed item
  Returns:
    Integer - index position in the Array of the passed item
  Examples:
    ['hi','there'].indexOf("guys") === -1
    ['hi','there'].indexOf("hi") === 0
*/
if (!Array.prototype.indexOf)
{
    Array.prototype.indexOf = function(item, fromIndex, compareFunc)
    {
        if (!fromIndex)
        {
            fromIndex = -1;
        }
        var index = -1;
        for (var i = fromIndex; i < this.length; i++)
        {
            if (this[i] === item || compareFunc && compareFunc(this[i], item))
            {
                index = i;
                break;
            }
        }
        return index;
    };
}

/*
  You can override this list for all Strings or just one depending on if you
  set the new values on prototype or on a given String instance.
*/
if (!String.prototype._uncountable_words)
{
    String.prototype._uncountable_words = InflectionJS.uncountable_words;
}

/*
  You can override this list for all Strings or just one depending on if you
  set the new values on prototype or on a given String instance.
*/
if (!String.prototype._plural_rules)
{
    String.prototype._plural_rules = InflectionJS.plural_rules;
}

/*
  You can override this list for all Strings or just one depending on if you
  set the new values on prototype or on a given String instance.
*/
if (!String.prototype._singular_rules)
{
    String.prototype._singular_rules = InflectionJS.singular_rules;
}

/*
  You can override this list for all Strings or just one depending on if you
  set the new values on prototype or on a given String instance.
*/
if (!String.prototype._non_titlecased_words)
{
    String.prototype._non_titlecased_words = InflectionJS.non_titlecased_words;
}

/*
  This function adds plurilization support to every String object
    Signature:
      String.pluralize(plural) == String
    Arguments:
      plural - String (optional) - overrides normal output with said String
    Returns:
      String - singular English language nouns are returned in plural form
    Examples:
      "person".pluralize() == "people"
      "octopus".pluralize() == "octopi"
      "Hat".pluralize() == "Hats"
      "person".pluralize("guys") == "guys"
*/
if (!String.prototype.pluralize)
{
    String.prototype.pluralize = function(plural)
    {
        return InflectionJS.apply_rules(
            this,
            this._plural_rules,
            this._uncountable_words,
            plural
        );
    };
}

/*
  This function adds singularization support to every String object
    Signature:
      String.singularize(singular) == String
    Arguments:
      singular - String (optional) - overrides normal output with said String
    Returns:
      String - plural English language nouns are returned in singular form
    Examples:
      "people".singularize() == "person"
      "octopi".singularize() == "octopus"
      "Hats".singularize() == "Hat"
      "guys".singularize("person") == "person"
*/
if (!String.prototype.singularize)
{
    String.prototype.singularize = function(singular)
    {
        return InflectionJS.apply_rules(
            this,
            this._singular_rules,
            this._uncountable_words,
            singular
        );
    };
}

/*
  This function adds camelization support to every String object
    Signature:
      String.camelize(lowFirstLetter) == String
    Arguments:
      lowFirstLetter - boolean (optional) - default is to capitalize the first
        letter of the results... passing true will lowercase it
    Returns:
      String - lower case underscored words will be returned in camel case
        additionally '/' is translated to '::'
    Examples:
      "message_properties".camelize() == "MessageProperties"
      "message_properties".camelize(true) == "messageProperties"
*/
if (!String.prototype.camelize)
{
     String.prototype.camelize = function(lowFirstLetter)
     {
        var str = this.toLowerCase();
        var str_path = str.split('/');
        for (var i = 0; i < str_path.length; i++)
        {
            var str_arr = str_path[i].split('_');
            var initX = ((lowFirstLetter && i + 1 === str_path.length) ? (1) : (0));
            for (var x = initX; x < str_arr.length; x++)
            {
                str_arr[x] = str_arr[x].charAt(0).toUpperCase() + str_arr[x].substring(1);
            }
            str_path[i] = str_arr.join('');
        }
        str = str_path.join('::');
        return str;
    };
}

/*
  This function adds underscore support to every String object
    Signature:
      String.underscore() == String
    Arguments:
      N/A
    Returns:
      String - camel cased words are returned as lower cased and underscored
        additionally '::' is translated to '/'
    Examples:
      "MessageProperties".camelize() == "message_properties"
      "messageProperties".underscore() == "message_properties"
*/
if (!String.prototype.underscore)
{
     String.prototype.underscore = function()
     {
        var str = this;
        var str_path = str.split('::');
        for (var i = 0; i < str_path.length; i++)
        {
            str_path[i] = str_path[i].replace(InflectionJS.uppercase, '_$1');
            str_path[i] = str_path[i].replace(InflectionJS.underbar_prefix, '');
        }
        str = str_path.join('/').toLowerCase();
        return str;
    };
}

/*
  This function adds humanize support to every String object
    Signature:
      String.humanize(lowFirstLetter) == String
    Arguments:
      lowFirstLetter - boolean (optional) - default is to capitalize the first
        letter of the results... passing true will lowercase it
    Returns:
      String - lower case underscored words will be returned in humanized form
    Examples:
      "message_properties".humanize() == "Message properties"
      "message_properties".humanize(true) == "message properties"
*/
if (!String.prototype.humanize)
{
    String.prototype.humanize = function(lowFirstLetter)
    {
        var str = this.toLowerCase();
        str = str.replace(InflectionJS.id_suffix, '');
        str = str.replace(InflectionJS.underbar, ' ');
        if (!lowFirstLetter)
        {
            str = str.capitalize();
        }
        return str;
    };
}

/*
  This function adds capitalization support to every String object
    Signature:
      String.capitalize() == String
    Arguments:
      N/A
    Returns:
      String - all characters will be lower case and the first will be upper
    Examples:
      "message_properties".capitalize() == "Message_properties"
      "message properties".capitalize() == "Message properties"
*/
if (!String.prototype.capitalize)
{
    String.prototype.capitalize = function()
    {
        var str = this.toLowerCase();
        str = str.substring(0, 1).toUpperCase() + str.substring(1);
        return str;
    };
}

/*
  This function adds dasherization support to every String object
    Signature:
      String.dasherize() == String
    Arguments:
      N/A
    Returns:
      String - replaces all spaces or underbars with dashes
    Examples:
      "message_properties".capitalize() == "message-properties"
      "Message Properties".capitalize() == "Message-Properties"
*/
if (!String.prototype.dasherize)
{
    String.prototype.dasherize = function()
    {
        var str = this;
        str = str.replace(InflectionJS.space_or_underbar, '-');
        return str;
    };
}

/*
  This function adds titleize support to every String object
    Signature:
      String.titleize() == String
    Arguments:
      N/A
    Returns:
      String - capitalizes words as you would for a book title
    Examples:
      "message_properties".titleize() == "Message Properties"
      "message properties to keep".titleize() == "Message Properties to Keep"
*/
if (!String.prototype.titleize)
{
    String.prototype.titleize = function()
    {
        var str = this.toLowerCase();
        str = str.replace(InflectionJS.underbar, ' ');
        var str_arr = str.split(' ');
        for (var x = 0; x < str_arr.length; x++)
        {
            var d = str_arr[x].split('-');
            for (var i = 0; i < d.length; i++)
            {
                if (this._non_titlecased_words.indexOf(d[i].toLowerCase()) < 0)
                {
                    d[i] = d[i].capitalize();
                }
            }
            str_arr[x] = d.join('-');
        }
        str = str_arr.join(' ');
        str = str.substring(0, 1).toUpperCase() + str.substring(1);
        return str;
    };
}

/*
  This function adds demodulize support to every String object
    Signature:
      String.demodulize() == String
    Arguments:
      N/A
    Returns:
      String - removes module names leaving only class names (Ruby style)
    Examples:
      "Message::Bus::Properties".demodulize() == "Properties"
*/
if (!String.prototype.demodulize)
{
    String.prototype.demodulize = function()
    {
        var str = this;
        var str_arr = str.split('::');
        str = str_arr[str_arr.length - 1];
        return str;
    };
}

/*
  This function adds tableize support to every String object
    Signature:
      String.tableize() == String
    Arguments:
      N/A
    Returns:
      String - renders camel cased words into their underscored plural form
    Examples:
      "MessageBusProperty".tableize() == "message_bus_properties"
*/
if (!String.prototype.tableize)
{
    String.prototype.tableize = function()
    {
        var str = this;
        str = str.underscore().pluralize();
        return str;
    };
}

/*
  This function adds classification support to every String object
    Signature:
      String.classify() == String
    Arguments:
      N/A
    Returns:
      String - underscored plural nouns become the camel cased singular form
    Examples:
      "message_bus_properties".classify() == "MessageBusProperty"
*/
if (!String.prototype.classify)
{
    String.prototype.classify = function()
    {
        var str = this;
        str = str.camelize().singularize();
        return str;
    };
}

/*
  This function adds foreign key support to every String object
    Signature:
      String.foreign_key(dropIdUbar) == String
    Arguments:
      dropIdUbar - boolean (optional) - default is to seperate id with an
        underbar at the end of the class name, you can pass true to skip it
    Returns:
      String - camel cased singular class names become underscored with id
    Examples:
      "MessageBusProperty".foreign_key() == "message_bus_property_id"
      "MessageBusProperty".foreign_key(true) == "message_bus_propertyid"
*/
if (!String.prototype.foreign_key)
{
    String.prototype.foreign_key = function(dropIdUbar)
    {
        var str = this;
        str = str.demodulize().underscore() + ((dropIdUbar) ? ('') : ('_')) + 'id';
        return str;
    };
}

/*
  This function adds ordinalize support to every String object
    Signature:
      String.ordinalize() == String
    Arguments:
      N/A
    Returns:
      String - renders all found numbers their sequence like "22nd"
    Examples:
      "the 1 pitch".ordinalize() == "the 1st pitch"
*/
if (!String.prototype.ordinalize)
{
    String.prototype.ordinalize = function()
    {
        var str = this;
        var str_arr = str.split(' ');
        for (var x = 0; x < str_arr.length; x++)
        {
            var i = parseInt(str_arr[x]);
            if (i === NaN)
            {
                var ltd = str_arr[x].substring(str_arr[x].length - 2);
                var ld = str_arr[x].substring(str_arr[x].length - 1);
                var suf = "th";
                if (ltd != "11" && ltd != "12" && ltd != "13")
                {
                    if (ld === "1")
                    {
                        suf = "st";
                    }
                    else if (ld === "2")
                    {
                        suf = "nd";
                    }
                    else if (ld === "3")
                    {
                        suf = "rd";
                    }
                }
                str_arr[x] += suf;
            }
        }
        str = str_arr.join(' ');
        return str;
    };
}
var theoricus = exports.theoricus = {'commands':{},'crawler':{},'generators':{}};

(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  theoricus.commands.Server = (function() {
    var exec, fs, http, path, pn, url;

    http = require("http");

    url = require("url");

    fs = require("fs");

    path = require("path");

    pn = path.normalize;

    exec = require("child_process").exec;

    function Server(the) {
      this.the = the;
      this._handler = __bind(this._handler, this);

      this.port = "11235";
      this.root = "" + this.the.pwd + "/public";
      this.compiler = new theoricus.commands.Compiler(this.the, true);
      this.start_server();
    }

    Server.prototype.start_server = function() {
      this.server = http.createServer(this._handler).listen(this.port);
      return console.log(("" + 'Server running at'.bold + " http://localhost:" + this.port).grey);
    };

    Server.prototype.close_server = function() {
      return this.server.close();
    };

    Server.prototype._handler = function(request, response) {
      var agent, crawl, filename, headers, uri,
        _this = this;
      headers = request.headers;
      agent = headers['user-agent'];
      crawl = agent.indexOf("Googlebot") >= 0 || agent.indexOf("curl") >= 0;
      uri = url.parse(request.url).pathname;
      filename = path.join(this.root, uri);
      return fs.exists(filename, function(exists) {
        var cache, file, src;
        if (!exists || fs.lstatSync(filename).isDirectory()) {
          filename = path.join(_this.root, "/index.html");
          file = fs.readFileSync(filename, "utf-8");
          response.writeHead(200, {
            "Content-Type": "text/html"
          });
          if (crawl === true) {
            cache = pn("" + _this.root + "/static/" + request.url + "/index.html");
            if (fs.existsSync(cache)) {
              src = fs.readFileSync(cache);
              response.writeHead(200, {
                "Content-Type": "text/html"
              });
              response.write("" + src + "\n");
              response.end();
            } else {
              console.log("TODO: implement on-demmand cache");
            }
          } else {
            response.write(file);
            response.end();
          }
          return;
        }
        return fs.readFile(filename, "binary", function(err, file) {
          var mime;
          if (err) {
            response.writeHead(500, {
              "Content-Type": "text/plain"
            });
            response.write(err + "\n");
            response.end();
            return;
          }
          if (filename.match(/.js$/m)) {
            response.writeHead(200, {
              "Content-Type": "text/javascript"
            });
          } else if ((mime = filename.match(/(jpg|png|gif)$/m))) {
            response.writeHead(200, {
              "Content-Type": "image/" + mime[1]
            });
          } else if (filename.match(/.css$/m)) {
            response.writeHead(200, {
              "Content-Type": "text/css"
            });
          }
          response.write(file, "binary");
          return response.end();
        });
      });
    };

    return Server;

  })();

  theoricus.crawler.Crawler = (function() {
    var phantom;

    phantom = require("phantom");

    Crawler.prototype.page = null;

    function Crawler(after_init) {
      var _this = this;
      phantom.create(function(ph) {
        _this.ph = ph;
        return _this.ph.createPage(function(page) {
          _this.page = page;
          return typeof after_init === "function" ? after_init() : void 0;
        });
      });
    }

    Crawler.prototype.get_src = function(url, on_get_source) {
      var _this = this;
      return this.page.open(url, function() {
        return _this.keep_on_checking(on_get_source);
      });
    };

    Crawler.prototype.keep_on_checking = function(on_get_source) {
      var _this = this;
      return this.page.evaluate((function() {
        return [window.crawler.is_rendered, document.all[0].outerHTML];
      }), function(data) {
        var rendered, source;
        rendered = data[0], source = data[1];
        if (rendered) {
          return on_get_source(source);
        }
        return setTimeout((function() {
          return _this.keep_on_checking(on_get_source);
        }), 10);
      });
    };

    Crawler.prototype.exit = function() {
      return this.ph.exit();
    };

    return Crawler;

  })();

  theoricus.generators.Controller = (function() {
    var fs;

    fs = require('fs');

    function Controller(the, name) {
      var contents, filepath, model_name, model_name_lc, name_camel, name_lc, tmpl;
      this.the = the;
      name_camel = name.camelize();
      name_lc = name.toLowerCase();
      model_name = name.singularize().camelize();
      model_name_lc = model_name.toLowerCase();
      tmpl = "" + this.the.root + "/cli/src/generators/templates/mvc/controller.coffee";
      filepath = "app/controllers/" + (name.toLowerCase()) + ".coffee";
      contents = (fs.readFileSync(tmpl)).toString();
      contents = contents.replace(/~NAME_CAMEL/g, name_camel);
      contents = contents.replace(/~NAME_LC/g, name_lc);
      contents = contents.replace(/~MODEL_CAMEL/g, model_name);
      contents = contents.replace(/~MODEL_LCASE/g, model_name_lc);
      fs.writeFileSync(filepath, contents);
      console.log(("" + 'Created'.bold + " " + filepath).green);
    }

    return Controller;

  })();

  theoricus.generators.Model = (function() {
    var fs;

    fs = require('fs');

    function Model(the, name) {
      var contents, controller_name_lc, filepath, name_camel, name_lc, tmpl;
      this.the = the;
      name_camel = name.camelize();
      name_lc = name.toLowerCase();
      controller_name_lc = name.pluralize().toLowerCase();
      tmpl = "" + this.the.root + "/cli/src/generators/templates/mvc/model.coffee";
      filepath = "app/models/" + name + ".coffee";
      contents = (fs.readFileSync(tmpl)).toString();
      contents = contents.replace(/~NAME_CAMEL/g, name_camel);
      contents = contents.replace(/~CONTROLLER_LC/g, controller_name_lc);
      fs.writeFileSync(filepath, contents);
      console.log(("" + 'Created'.bold + " " + filepath).green);
    }

    return Model;

  })();

  theoricus.generators.View = (function() {
    var fs, fsu;

    fs = require('fs');

    fsu = require('fs-util');

    function View(the, name, controller_name_lc, mvc) {
      var contents, jade_path, name_camel, name_lc, static_folder, styl_path, tmpl_jade, tmpl_path, tmpl_styl, tmpl_view, view_folder, view_path;
      this.the = the;
      if (mvc == null) {
        mvc = false;
      }
      name_camel = name.camelize();
      name_lc = name.toLowerCase();
      view_folder = "app/views/" + controller_name_lc;
      static_folder = "app/static/" + controller_name_lc;
      if (mvc) {
        view_path = "" + view_folder + "/index.coffee";
      } else {
        view_path = "" + view_folder + "/" + name_lc + ".coffee";
      }
      jade_path = "" + static_folder + "/index.jade";
      styl_path = "" + static_folder + "/index.styl";
      tmpl_path = "" + this.the.root + "/cli/src/generators/templates/mvc";
      tmpl_view = "" + tmpl_path + "/view.coffee";
      tmpl_jade = "" + tmpl_path + "/view.jade";
      tmpl_styl = "" + tmpl_path + "/view.styl";
      fsu.mkdir_p(view_folder);
      fsu.mkdir_p(static_folder);
      contents = (fs.readFileSync(tmpl_view)).toString();
      contents = contents.replace(/~NAME_CAMEL/g, name_camel);
      contents = contents.replace(/~CONTROLLER_NAME_LC/g, controller_name_lc);
      fs.writeFileSync(view_path, contents);
      console.log(("" + 'Created'.bold + " " + view_path).green);
      fs.writeFileSync(jade_path, fs.readFileSync(tmpl_jade));
      console.log(("" + 'Created'.bold + " " + jade_path).green);
      fs.writeFileSync(styl_path, fs.readFileSync(tmpl_styl));
      console.log(("" + 'Created'.bold + " " + styl_path).green);
    }

    return View;

  })();

  theoricus.commands.Add = (function() {
    var Controller, Model, View, _ref;

    _ref = theoricus.generators, Model = _ref.Model, Controller = _ref.Controller, View = _ref.View;

    function Add(the, opts) {
      var args, error_msg, name, type;
      this.the = the;
      type = opts[1];
      name = opts[2];
      args = opts.slice(3);
      if (this[type] == null) {
        error_msg = "Valid options: controller, model, view, mvc.";
        throw new Error(error_msg);
      }
      this[type](name, args);
    }

    Add.prototype.mvc = function(name, args) {
      this.model(name.singularize(), args);
      this.view("" + (name.singularize()) + "/index");
      return this.controller(name);
    };

    Add.prototype.model = function(name, args) {
      return new Model(this.the, name, args);
    };

    Add.prototype.view = function(path) {
      var error_msg, folder, name, parts;
      folder = (parts = path.split('/'))[0];
      name = parts[1];
      if (name == null) {
        error_msg = "Views should be removed with path-style notation.\n\n\ti.e.:\n\t\t theoricus add view person/index\n\t\t theoricus add view user/list\n";
        throw new Error(error_msg);
        return;
      }
      return new View(this.the, name, folder);
    };

    Add.prototype.controller = function(name) {
      return new Controller(this.the, name);
    };

    return Add;

  })();

  theoricus.commands.AddProject = (function() {
    var exec, fs, path, pn;

    fs = require('fs');

    path = require('path');

    pn = path.normalize;

    exec = (require("child_process")).exec;

    function AddProject(the, options) {
      var cmd,
        _this = this;
      this.the = the;
      this.options = options;
      this.pwd = this.the.pwd;
      this.root = this.the.root;
      this.app_skel = pn("" + this.root + "/cli/src/generators/templates/app_skel");
      this.target = pn("" + this.pwd + "/" + this.options[1]);
      if (fs.existsSync(this.target)) {
        console.log("ERROR".bold.red + " Target directory already existis." + ("\n\t" + this.target).yellow);
        return;
      }
      cmd = "cp -r " + this.app_skel + " " + this.target;
      exec(cmd, function(error, stdout, stderr) {
        if (error != null) {
          return console.log(error);
        } else {
          return exec("find " + _this.target, function(error, stdout, stderr) {
            var file, files, _i, _len, _results;
            files = stdout.split("\n").slice(0, -1);
            _results = [];
            for (_i = 0, _len = files.length; _i < _len; _i++) {
              file = files[_i];
              _results.push(console.log(("" + 'Created'.bold + " " + file).green));
            }
            return _results;
          });
        }
      });
    }

    return AddProject;

  })();

  theoricus.commands.Compiler = (function() {
    var ArrayUtil, FnUtil, Toaster, fs, fsu, jade, nib, path, stylus, _ref;

    path = require("path");

    fs = require("fs");

    nib = require("nib");

    fsu = require('fs-util');

    jade = require("jade");

    stylus = require("stylus");

    Toaster = require('coffee-toaster').Toaster;

    _ref = require('coffee-toaster').toaster.utils, FnUtil = _ref.FnUtil, ArrayUtil = _ref.ArrayUtil;

    Compiler.prototype.BASE_DIR = "";

    Compiler.prototype.APP_FOLDER = "";

    function Compiler(the, watch) {
      var config, reg, watcher,
        _this = this;
      this.the = the;
      if (watch == null) {
        watch = false;
      }
      this._on_jade_stylus_change = __bind(this._on_jade_stylus_change, this);

      this.BASE_DIR = this.the.pwd;
      this.APP_FOLDER = "" + this.BASE_DIR + "/app";
      config = {
        folders: {},
        vendors: ["" + this.the.root + "/lib/theoricus.js"],
        minify: false,
        release: "public/app.js",
        debug: "public/app-debug.js"
      };
      config.folders[this.APP_FOLDER] = "app";
      this.toaster = new Toaster(this.BASE_DIR, {
        w: watch,
        c: !watch,
        d: 1,
        config: config
      }, true);
      this.toaster.before_build = function() {
        _this.compile();
        return false;
      };
      this.compile();
      if (!watch) {
        return;
      }
      reg = /(.jade|.styl)$/m;
      watcher = fsu.watch("" + this.APP_FOLDER + "/static", reg);
      watcher.on('create', FnUtil.proxy(this._on_jade_stylus_change, 'create'));
      watcher.on('update', FnUtil.proxy(this._on_jade_stylus_change, 'update'));
      watcher.on('delete', FnUtil.proxy(this._on_jade_stylus_change, 'delete'));
    }

    Compiler.prototype._on_jade_stylus_change = function(ev, f) {
      var msg, now, type,
        _this = this;
      if (f.type === "dir" && ev === "created") {
        return;
      }
      now = (("" + (new Date)).match(/[0-9]{2}\:[0-9]{2}\:[0-9]{2}/))[0];
      switch (info.action) {
        case "created":
          msg = "New file created".bold.cyan;
          console.log(("[" + now + "] " + msg + " " + info.path).green);
          break;
        case "deleted":
          type = info.type === "file" ? "File" : "Folder";
          msg = ("" + type + " deleted").bold.red;
          console.log(("[" + now + "] {msg} " + info.path).red);
          break;
        case "updated":
          msg = "File changed".bold.cyan;
          console.log(("[" + now + "] " + msg + " " + info.path).cyan);
      }
      if (info.path.match(/.jade$/m)) {
        return this.compile(true);
      } else if (info.path.match(/.styl$/m)) {
        return this.compile_stylus(function(css) {
          var target;
          target = "" + _this.the.pwd + "/public/app.css";
          fs.writeFileSync(target, css);
          return console.log(("[" + now + "] " + 'Compiled'.bold + " " + target).green);
        });
      }
    };

    Compiler.prototype.compile_jade = function(after_compile) {
      var buffer, compiled, file, files, name, output, source, _i, _len;
      files = fsu.find("" + this.APP_FOLDER + "/static", /.jade$/);
      output = "(function() {\n	app.templates = { ~TEMPLATES };\n}).call( this );";
      buffer = [];
      for (_i = 0, _len = files.length; _i < _len; _i++) {
        file = files[_i];
        if (/^_/m.test(file)) {
          continue;
        }
        name = (file.match(/static\/(.*).jade$/m))[1];
        source = fs.readFileSync(file, "utf-8");
        compiled = jade.compile(source, {
          filename: file,
          client: true,
          compileDebug: false
        });
        compiled = compiled.toString().replace("anonymous", "");
        buffer.push(("'" + name + "': ") + compiled);
      }
      output = output.replace("~TEMPLATES", buffer.join(","));
      output = this.to_single_line(output);
      return "// TEMPLATES\n" + output;
    };

    Compiler.prototype.compile_stylus = function(after_compile) {
      var buffer, file, files, paths, source, _i, _j, _len, _len1, _results,
        _this = this;
      files = fsu.find("" + this.APP_FOLDER + "/static", /.styl$/);
      buffer = [];
      this.pending_stylus = 0;
      for (_i = 0, _len = files.length; _i < _len; _i++) {
        file = files[_i];
        if (file.match(/(\_)?[^\/]+$/)[1] !== "_") {
          this.pending_stylus++;
        }
      }
      _results = [];
      for (_j = 0, _len1 = files.length; _j < _len1; _j++) {
        file = files[_j];
        if (file.match(/(\_)?[^\/]+$/)[1] === "_") {
          continue;
        }
        source = fs.readFileSync(file, "utf-8");
        paths = ["" + this.APP_FOLDER + "/static/_mixins/stylus"];
        _results.push(stylus(source).set('filename', file).set('paths', paths).use(nib()).render(function(err, css) {
          if (err != null) {
            throw err;
          }
          buffer.push(css);
          if (--_this.pending_stylus === 0) {
            return after_compile(buffer.join("\n"));
          }
        }));
      }
      return _results;
    };

    Compiler.prototype.compile = function() {
      var conf, footer, header, now, templates,
        _this = this;
      conf = this._get_config();
      templates = this.compile_jade();
      header = "" + templates + "\n\n" + conf.config + "\n\n" + conf.routes + "\n\n" + conf.root + "\n";
      footer = "new theoricus.Theoricus";
      this.toaster.build(header, footer);
      now = (("" + (new Date)).match(/[0-9]{2}\:[0-9]{2}\:[0-9]{2}/))[0];
      return this.compile_stylus(function(css) {
        var target;
        target = "" + _this.the.pwd + "/public/app.css";
        fs.writeFileSync(target, css);
        return console.log(("[" + now + "] " + 'Compiled'.bold + " " + target).green);
      });
    };

    Compiler.prototype._get_config = function() {
      var app, routes;
      app = "" + this.the.pwd + "/config/app.coffee";
      routes = "" + this.the.pwd + "/config/routes.coffee";
      app = fs.readFileSync(app, "utf-8");
      routes = fs.readFileSync(routes, "utf-8");
      return new theoricus.commands.Config(app, routes);
    };

    Compiler.prototype.to_single_line = function(code) {
      return theoricus.commands.Compiler.to_single_line(code);
    };

    Compiler.to_single_line = function(code, ugli) {
      return code.replace(/(^\/\/.*)|([\t\n]+)/gm, "");
    };

    return Compiler;

  })();

  theoricus.commands.Config = (function() {
    var Compiler, cs, fs;

    Compiler = theoricus.commands.Compiler;

    fs = require("fs");

    cs = require("coffee-script");

    Config.prototype.config = null;

    Config.prototype.routes = null;

    Config.prototype.root = null;

    function Config(app, routes) {
      this._parse_app(app);
      this._parse_routes(routes);
    }

    Config.prototype._parse_app = function(app) {
      var tmp;
      try {
        tmp = {};
        app = cs.compile(app.replace(/(^\w)/gm, "tmp.$1"), {
          bare: 1
        });
        eval(app);
      } catch (error) {
        throw error;
      }
      return this.config = "// CONFIG\n" + Compiler.to_single_line("(function() {\n	app.config = {\n		animate_at_startup: " + tmp.animate_at_startup + ",\n		enable_auto_transitions: " + tmp.enable_auto_transitions + "\n	};\n}).call( this );");
    };

    Config.prototype._parse_routes = function(routes) {
      var buffer, root, tmp;
      buffer = [];
      root = null;
      try {
        tmp = {
          root: function(route) {
            return root = route;
          },
          match: function(route, options) {
            route = "'" + route + "': {\n	to: '" + options.to + "',\n	at: '" + options.at + "',\n	el: '" + options.el + "'\n}";
            return buffer.push(route.replace("'null'", null));
          }
        };
        routes = cs.compile(routes.replace(/(^\w)/gm, "tmp.$1"), {
          bare: 1
        });
        eval(routes);
      } catch (error) {
        throw error;
      }
      this.root = "// ROOT\n" + Compiler.to_single_line("(function() {\n	app.root = '" + root + "';\n\n}).call( this );", true);
      return this.routes = "// ROUTES\n" + Compiler.to_single_line("(function() {\n	app.routes = {\n		" + (buffer.join(",")) + "\n	};\n}).call( this );", true);
    };

    return Config;

  })();

  theoricus.commands.Index = (function() {
    var exec, fs, fsu, path;

    fs = require("fs");

    exec = (require("child_process")).exec;

    path = require("path");

    fsu = require("fs-util");

    Index.prototype.pages = {};

    function Index(the, options) {
      var _this = this;
      this.the = the;
      this.options = options;
      exec("phantomjs -v", function(error, stdout, stderr) {
        if (/phantomjs: command not found/.test(stderr)) {
          return console.log("Error ".bold.red + ("Install " + 'phantomjs'.yellow) + " before indexing pages." + "\n\thttp://phantomjs.org/");
        } else {
          _this.server = new theoricus.commands.Server(_this.the, _this.options);
          console.log("Start indexing...".bold.green);
          return _this.crawler = new theoricus.crawler.Crawler(function() {
            return _this.get_page("http://localhost:11235/");
          });
        }
      });
    }

    Index.prototype.get_page = function(url) {
      var _this = this;
      return this.crawler.get_src(url, function(src) {
        var crawled, from, to, _ref;
        _this.get_links(url, src);
        _this.save_page(url, src);
        _this.pages[url] = true;
        _ref = _this.pages;
        for (url in _ref) {
          crawled = _ref[url];
          if (!crawled) {
            return _this.get_page(url);
          }
        }
        from = "" + _this.the.pwd + "/public";
        to = "" + _this.the.pwd + "/public/static";
        fs.writeFileSync("" + to + "/app.js", "");
        src = fs.readFileSync("" + from + "/app.css", "utf-8");
        fs.writeFileSync("" + to + "/app.css", src);
        console.log("Pages indexed successfully.".bold.green);
        _this.crawler.exit();
        _this.server.close_server();
        return _this.static_server = new theoricus.commands.StaticServer(_this.the, _this.options);
      });
    };

    Index.prototype.get_links = function(url, src) {
      var domain, matched, reg, _results;
      domain = url.match(/(http:\/\/[\w]+:?[0-9]*)/g);
      reg = /a\shref=(\"|\')(\/)?([^\'\"]+)/g;
      _results = [];
      while ((matched = reg.exec(src)) != null) {
        url = "" + domain + "/" + matched[3];
        if (this.pages[url] !== true) {
          _results.push(this.pages[url] = false);
        } else {
          _results.push(void 0);
        }
      }
      return _results;
    };

    Index.prototype.save_page = function(url, src) {
      var file, folder, route;
      route = (/(http:\/\/)([\w]+)(:)?([0-9]+)?\/(.*)/g.exec(url))[5];
      folder = path.normalize("" + this.the.pwd + "/public/static/" + route);
      if (!fs.existsSync(folder)) {
        fsu.mkdir_p(folder);
      }
      src = ((require('pretty-data')).pd.xml(src)) + "\n";
      fs.writeFileSync((file = path.normalize("" + folder + "/index.html")), src);
      route = (route || "/").bold.yellow;
      return console.log("\t" + route.bold.yellow + " -> " + file);
    };

    return Index;

  })();

  theoricus.commands.Rm = (function() {
    var fs, fsu, path;

    fs = require('fs');

    path = require('path');

    fsu = require("fs-util");

    function Rm(the, opts) {
      var error_msg, name, type;
      this.the = the;
      type = opts[1];
      name = opts[2];
      this.recursive = (opts[3] != null) && /\-\-rf/.test(opts[3]);
      this.APP_FOLDER = "" + this.the.pwd + "/app";
      if (this[type] == null) {
        error_msg = "Valid options: controller, model, view, mvc.";
        throw new Error(error_msg);
      }
      this[type](name);
    }

    Rm.prototype.mvc = function(name) {
      this.model(name.singularize());
      this.view("" + (name.singularize()) + "/index");
      return this.controller(name);
    };

    Rm.prototype.model = function(name) {
      return this.rm("" + this.APP_FOLDER + "/models/" + name + ".coffee");
    };

    Rm.prototype.view = function(path) {
      var error_msg, folder, name, parts;
      folder = (parts = path.split('/'))[0];
      name = parts[1];
      if (!((name != null) || this.recursive)) {
        error_msg = "Views should be removed with path-style notation.\n\n\ti.e.:\n\t\t theoricus rm view person/index\n\t\t theoricus rm view user/list\n";
        throw new Error(error_msg);
        return;
      }
      if (this.recursive) {
        this.rm("" + this.APP_FOLDER + "/views/" + folder);
        return this.rm("" + this.APP_FOLDER + "/static/" + folder);
      } else {
        this.rm("" + this.APP_FOLDER + "/views/" + folder + "/" + name + ".coffee");
        this.rm("" + this.APP_FOLDER + "/static/" + folder + "/" + name + ".jade");
        return this.rm("" + this.APP_FOLDER + "/static/" + folder + "/" + name + ".styl");
      }
    };

    Rm.prototype.controller = function(name, args, mvc) {
      if (mvc == null) {
        mvc = false;
      }
      return this.rm("" + this.APP_FOLDER + "/controllers/" + name + ".coffee");
    };

    Rm.prototype.rm = function(filepath) {
      var rpath;
      rpath = filepath.match(/app\/.*/);
      if (fs.existsSync(filepath)) {
        try {
          if (fs.lstatSync(filepath).isDirectory()) {
            if (this.recursive) {
              fsu.rmdir_rf(filepath);
            } else {
              fs.rmDirSync(filepath);
            }
          } else {
            fs.unlinkSync(filepath);
          }
        } catch (err) {
          throw new Error(err);
        }
        return console.log(("" + 'Removed'.bold + " " + rpath).red);
      } else {
        return console.log(("" + 'Not found'.bold + " " + rpath).yellow);
      }
    };

    return Rm;

  })();

  theoricus.commands.StaticServer = (function() {
    var HTTPServer;

    HTTPServer = require("http-server");

    function StaticServer(the, options) {
      var server,
        _this = this;
      this.the = the;
      this.port = "11235";
      this.root = "" + this.the.pwd + "/public/static";
      server = HTTPServer.createServer({
        root: this.root,
        port: this.port,
        autoIndex: true
      });
      server.listen(this.port, "0.0.0.0", function() {
        var msg;
        msg = ("" + 'Static server running at'.bold + " http://localhost:" + _this.port).grey;
        return console.log(msg);
      });
    }

    return StaticServer;

  })();

  exports.run = function() {
    return new theoricus.Theoricus;
  };

  theoricus.Theoricus = (function() {
    var colors, fs, path;

    fs = require("fs");

    path = require("path");

    colors = require('colors');

    function Theoricus() {
      var cmd, cmds, options, _ref;
      this.root = path.normalize(__dirname + "/..");
      this.app_root = this._get_app_root();
      this.pwd = this.app_root || path.resolve(".");
      this.version = (require("" + this.root + "/package.json")).version;
      cmds = ("" + 'model'.cyan + '|'.white + 'view'.cyan + '|'.white) + ("" + 'controller'.cyan + '|'.white + 'mvc'.cyan);
      this.header = ("" + 'Theoricus'.bold + " ") + ("v" + this.version + "\nCoffeeScript MVC implementation for the browser + lazy navigation mechanism.\n\n").grey;
      this.header += "" + 'Usage:'.bold + "\n";
      this.header += "  theoricus " + 'new'.red + "      " + 'path'.green + "\n";
      this.header += "  theoricus " + 'add'.red + "      " + cmds + " \n";
      this.header += "  theoricus " + 'rm'.red + "       " + cmds + " \n";
      this.header += "  theoricus " + 'start'.red + "    \n";
      this.header += "  theoricus " + 'compile'.red + "  \n";
      this.header += "  theoricus " + 'index'.red + "    \n\n";
      this.header += "" + 'Options:'.bold + "\n";
      this.header += "             " + 'new'.red + "   Creates a new working project in the file system.\n";
      this.header += "             " + 'add'.red + "   Generates a new model|view|controller file.\n";
      this.header += "              " + 'rm'.red + "   Destroy some model|view|controller file.\n";
      this.header += "           " + 'start'.red + "   Starts app in watch'n'compile mode at http://localhost:11235\n";
      this.header += "         " + 'compile'.red + "   Compile app to release destination.\n";
      this.header += "           " + 'index'.red + "   Index the whole application to a static non-js version.\n";
      this.header += "         " + 'version'.red + "   Show theoricus version.\n";
      this.header += "            " + 'help'.red + "   Show this help screen.\n";
      options = process.argv.slice(2);
      cmd = options.join(" ").match(/([a-z]+)/);
      if (cmd != null) {
        cmd = cmd[1];
      }
      if (this.app_root === null && cmd !== "help" && cmd !== "new") {
        console.log("ERROR".bold.red + " Not a Theoricus app.");
        return;
      }
      if ((_ref = options.watch) == null) {
        options.watch = false;
      }
      switch (cmd) {
        case "new":
          new theoricus.commands.AddProject(this, options);
          break;
        case "add":
          new theoricus.commands.Add(this, options);
          break;
        case "rm":
          new theoricus.commands.Rm(this, options);
          break;
        case "start":
          new theoricus.commands.Server(this);
          break;
        case "static":
          new theoricus.commands.StaticServer(this, options);
          break;
        case "compile":
          new theoricus.commands.Compiler(this);
          break;
        case "index":
          new theoricus.commands.Index(this, options);
          break;
        case "version":
          console.log(this.version);
          break;
        default:
          console.log(this.header);
      }
    }

    Theoricus.prototype._get_app_root = function() {
      var app, contents, current, tmp;
      current = path.resolve(".");
      while (true) {
        app = path.normalize("" + current + "/app/app_controller.coffee");
        if (fs.existsSync(app)) {
          contents = fs.readFileSync(app, "utf-8");
          if (contents.indexOf("theoricus.mvc.Controller") > 0) {
            return current;
          } else {
            return null;
          }
        } else {
          tmp = path.normalize(path.resolve("" + current + "/../"));
          if (current === tmp) {
            return null;
          } else {
            current = tmp;
            continue;
          }
        }
      }
    };

    return Theoricus;

  })();

}).call(this);

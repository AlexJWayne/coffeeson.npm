COFFESON
========

Coffeeson is a little syntax that compiles into JSON.  Underneath all those awkward braces and commas, JSON has always had a gorgeous data format at its heart. Coffeeson is an attempt to expose the good parts of JSON in a more human maintainable way.

;)

Why?
----

JSON is an awesome data exchange format.  But when a human has to maintain it, it's not quite so awesome.  Balanced braces, commas everywhere, and quoted key names make maintenance a bit tricky.

Coffeeson aims to solve that.  JavaScript powered applications, like node.js servers and the like, tend to use `json` files as configuration.  Humans write these files, but machines read them.

It is not meant to be a data exchange format, there is no way to save data as Coffeeson, only to convert it to JSON or parse it as JavaScript.  This is intentional.  You should still use JSON for machine -> machine data transmision.


SECURITY WARNING!
-----------------

Since it's designed for humans editing trusted files, it is much less secure than JSON.  Self executing functions will be run as coffee script parses the file.  So don't accept and parse Coffeeson from untrusted sources, that's what JSON is for.


Installation
------------

    npm install coffeeson


Syntax
------

So with that out of the way...

It works just like CoffeeScript, since it _is_ CoffeeScript.  Simply start listing keys of the root level object at the lowest indent level.

    pre: 123
    a:
      b:
        c: '456'
      d: [
        7
        8
        e:
          f: 'g'
      ]

That snippet would compile into this JSON.

    {
      "pre": 123,
      "a": {
        "b": {
          "c": "456"
        },
        "d": [
          7,
          8,
          {
            "e": {
              "f": "g"
            }
          }
        ]
      }
    }

Usage
-----

_(Examples will assume you are using coffee script.  Because if you aren't, chances are you are fine with JSON as it is.)_

With the npm module installed, simply require it.
    
    coffeeson = require 'coffeeson'


API
---

**.parse(coffeesonString)**

Simply parse a coffeeson string and return a JS native object.

    coffeeson.parse('a:123').a #=> 123

**.parseFile(path, callback(err, result))**

Asynchronously parse a coffeeson file and return a JS native object.

    coffeeson.parseFile 'config.coffeeson', (err, result) ->
      result.a #=> 123

**.toJSON(src)**

Parse a coffeeson string and return an equivalent JSON string.

    coffeeson.toJSON 'a:123' #=> '{"a":123}'

**.toJSON.pretty(src)**

Parse a coffeeson string and return an equivalent JSON string, nicely indented.

    coffeeson.toJSON.pretty 'a:b:123' #=> '''
                                          {
                                            "a": {
                                              "b": 123
                                            }
                                          }
                                          '''

**.fileToJSON(path, callback(err, json))**

Asynchronously read a file and callback with the content as JSON.

    coffeeson.fileToJSON 'config.coffeeson', (err, json) ->
      json #=> '{"a":{"b":123}}'

**.fileToJSON.pretty(path, callback(err, json))**

Asynchronously read a file and callback with the content as pretty and indented JSON.

    coffeeson.fileToJSON.pretty 'config.coffeeson', (err, json) ->
      json #=> '''
               {
                 "a": {
                   "b": 123
                 }
               }
               '''

**.convertFile(path, [callback(err)])**

Asynchronously read a file and save a .json file right next the source file.

    coffeeson.convertFile 'config.coffeeson', (err) ->
      # "config.json" now contains JSON version of "config.coffeeson"

**.convertFile.pretty(path, [callback(err)])**

Asynchronously read a file and save a pretty and indented .json file right next the source file.  Works exactly like `convertFile()`

    coffeeson.convertFile.pretty 'config.coffeeson', (err) ->
      # "config.json" now contains pretty JSON version of "config.coffeeson"










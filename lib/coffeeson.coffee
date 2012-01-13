coffee = require 'coffee-script'
fs     = require 'fs'


# @private - Compiles coffeeson content to JS with coffee-script
compile = (src) ->
  coffee.compile src.toString(), bare: yes

# Parse a coffeeson string and return a JS native object
parse = (src) ->
  eval compile(src)

# Parse a coffeeson file and return a JS native object
parseFile = (name, cb) ->
  fs.readFile name, (err, src) ->
    return cb err if err
    cb no, parse(src)

# Parse a coffeeson string and return JSON
toJSON = (src, replacer, spacer) ->
  JSON.stringify parse(src), replacer, spacer

# Parse a coffeeson string and return pretty JSON
toJSON.pretty = (src, replacer) ->
  toJSON src, replacer, 2

# Asynchronously read a file and callback with the content as JSON
fileToJSON = (name, args..., cb) ->
  fs.readFile name, (err, src) ->
    if cb
      return cb err if err
      cb no, toJSON(src, args...)
  return

# Asynchronously read a file and callback with the content as pretty JSON
fileToJSON.pretty = (name, cb) ->
  fileToJSON name, null, 2, cb

# Asynchronously read a file and save a .json file right next the source file
convertFile = (name, args..., cb) ->
  fileToJSON name, args..., (err, json) ->
    fs.writeFile name.replace(/\.coffeeson$/, '.json'), json, (err) ->
      if cb
        return cb err if err
        cb no, json
  return

# Asynchronously read a file and save a pretty .json file right next the source file
convertFile.pretty = (name, cb) ->
  convertFile name, null, 2, cb

# Export methods
module.exports = {
  parse
  parseFile
  toJSON
  fileToJSON
  convertFile
}
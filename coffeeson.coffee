coffee = require 'coffee-script'
fs     = require 'fs'

coffeeson = do ->  
  compile = (src) ->
    coffee.compile src.toString(), bare: yes
  
  parse = (src) ->
    eval compile(src)
  
  toJSON = (src, replacer, spacer) ->
    JSON.stringify parse(src), replacer, spacer
  
  toPrettyJSON = (src, replacer) ->
    toJSON src, replacer, 2
  
  fileToJSON = (name, args..., cb) ->
    fs.readFile name, (err, src) ->
      if cb
        return cb err if err
        cb null, toJSON(src, args...)
    return
  
  fileToPrettyJSON = (name, cb) ->
    fileToJSON name, null, 2, cb
  
  convertFile = (name, args..., cb) ->
    fileToJSON name, args..., (err, json) ->
      fs.writeFile name.replace(/\.coffeeson$/, '.json'), json, (err) ->
        if cb
          return cb err if err
          cb null, json
    return
  
  convertFilePretty = (name, cb) ->
    convertFile name, null, 2, cb
        
  
  return {
    parse
    toJSON
    toPrettyJSON
    fileToJSON
    fileToPrettyJSON
    convertFile
    convertFilePretty
  }

module.exports = coffeeson
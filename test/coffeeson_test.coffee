coffeeson = require '../lib/coffeeson'
fs        = require 'fs'
path      = require 'path'

# Src Data
src =
  simple:  'a: 123'
  complex:  '''
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
            '''

# Result Data
json =
  simple:  '{"a":123}'
  complex: '{"pre":123,"a":{"b":{"c":"456"},"d":[7,8,{"e":{"f":"g"}}]}}'
  complexPretty:'''
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
                '''
  

describe 'coffeeson', ->
  it '.parse() parses coffeeson', ->
    result = coffeeson.parse src.complex
    JSON.stringify(result).should.equal json.complex
  
  it '.parseFile() parses a coffeeson file and returns a native JS object', (done) ->
    coffeeson.parseFile 'test/sample.coffeeson', (err, result) ->
      err.should.not.be.ok
      JSON.stringify(result).should.equal json.complex
      done()
    
  
  it '.toJSON() jsonifies coffeeson', ->
    result = coffeeson.toJSON src.complex
    result.should.equal json.complex

  it '.toJSON.pretty() returns pretty indented json', ->
    result = coffeeson.toJSON.pretty src.complex
    result.should.equal json.complexPretty

  it '.fileToJSON() async reads of a coffeeson file on disk, returning equivalent JSON', (done) ->
    coffeeson.fileToJSON 'test/sample.coffeeson', (err, result) ->
      result.should.equal json.complex
      done()

  it '.fileToJSON.pretty() async reads of a coffeeson file on disk, returning equivalent pretty JSON', (done) ->
    coffeeson.fileToJSON.pretty 'test/sample.coffeeson', (err, result) ->
      result.should.equal json.complexPretty
      done()

  it '.convertFile() async reads a coffeeson file and writes a json file right next to it', (done) ->
    coffeeson.convertFile 'test/sample.coffeeson', (err) ->
      # ensure no error
      err.should.not.be.ok
      
      # Ensure the file was written
      path.exists 'test/sample.json', (exists) ->
        exists.should.be.ok
        
        # ensure the json content is right
        fs.readFile 'test/sample.json', (err, jsonContent) ->
          jsonContent.toString().should.equal json.complex
          
          # Cleanup our mess
          fs.unlink 'test/sample.json', done

  it '.convertFile.pretty() async reads a coffeeson file and writes a pretty json file right next to it', (done) ->
    coffeeson.convertFile.pretty 'test/sample.coffeeson', (err) ->
      # ensure no error
      err.should.not.be.ok
      
      # Ensure the file was written
      path.exists 'test/sample.json', (exists) ->
        exists.should.be.ok
        
        # ensure the json content is right
        fs.readFile 'test/sample.json', (err, jsonContent) ->
          jsonContent.toString().should.equal json.complexPretty
          
          # Cleanup our mess
          fs.unlink 'test/sample.json', done
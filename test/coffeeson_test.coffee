coffeeson = require '../coffeeson'
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
  describe '.toJSON', ->
    it 'jsonifies a simple object', ->
      result = coffeeson.toJSON src.simple
      result.should.equal json.simple
  
    it 'jsonifies a complex object', ->
      result = coffeeson.toJSON src.complex
      result.should.equal json.complex
  
  describe '.toPrettyJSON', ->
    it 'returns pretty indented json', ->
      result = coffeeson.toPrettyJSON src.complex
      result.should.equal json.complexPretty
  
  describe '.parse', ->
    it 'parses a simple object', ->
      result = coffeeson.parse src.simple
      JSON.stringify(result).should.equal json.simple
    
    it 'parses a complex object', ->
      result = coffeeson.parse src.complex
      JSON.stringify(result).should.equal json.complex
  
  describe '.fileToJSON', ->
    it 'async read of a coffeeson file on disk, returning equivalent JSON', (done) ->
      coffeeson.fileToJSON 'test/sample.coffeeson', (err, result) ->
        result.should.equal json.complex
        done()

  describe '.fileToPrettyJSON', ->
    it 'async read of a coffeeson file on disk, returning equivalent pretty JSON', (done) ->
      coffeeson.fileToPrettyJSON 'test/sample.coffeeson', (err, result) ->
        result.should.equal json.complexPretty
        done()
  
  describe '.convertFile', ->
    it 'async reads a coffeeson file and writes a json file right next to it', (done) ->
      coffeeson.convertFile 'test/sample.coffeeson', (err) ->
        # ensure no error
        (!!err).should.not.be.ok # should.js wtf?
        
        # Ensure the file was written
        path.exists 'test/sample.json', (exists) ->
          exists.should.be.ok
          
          # ensure the json content is right
          fs.readFile 'test/sample.json', (err, jsonContent) ->
            jsonContent.toString().should.equal json.complex
            
            # Cleanup our mess
            fs.unlink 'test/sample.json', done
  
  describe '.convertFilePretty', ->
    it 'async reads a coffeeson file and writes a pretty json file right next to it', (done) ->
      coffeeson.convertFilePretty 'test/sample.coffeeson', (err) ->
        # ensure no error
        (!!err).should.not.be.ok # should.js wtf?
        
        # Ensure the file was written
        path.exists 'test/sample.json', (exists) ->
          exists.should.be.ok
          
          # ensure the json content is right
          fs.readFile 'test/sample.json', (err, jsonContent) ->
            jsonContent.toString().should.equal json.complexPretty
            
            # Cleanup our mess
            fs.unlink 'test/sample.json', done
              

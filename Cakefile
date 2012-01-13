coffeeson = require './lib/coffeeson'
spawn     = require('child_process').spawn
fs        = require 'fs'

# Launch an executable form the src/server directory with arguments.
easySpawn = (cmd) ->
  args = cmd.split /\s+?/
  exe  = args.shift()
  spawn exe, args

task 'test', 'Run the tests', ->
  result = ''
  mocha = easySpawn 'node_modules/.bin/mocha --colors --require should --reporter spec'
  mocha.stderr.on 'data', (data) -> console.error data.toString()
  mocha.stdout.on 'data', (data) -> result += data
  mocha.on 'exit', -> console.log result

task 'build', 'Build the package.json file', ->
  easySpawn 'coffee -c lib'
  coffeeson.convertFile.pretty 'package.coffeeson'
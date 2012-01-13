(function() {
  var coffee, compile, convertFile, fileToJSON, fs, parse, parseFile, toJSON,
    __slice = Array.prototype.slice;

  coffee = require('coffee-script');

  fs = require('fs');

  compile = function(src) {
    return coffee.compile(src.toString(), {
      bare: true
    });
  };

  parse = function(src) {
    return eval(compile(src));
  };

  parseFile = function(name, cb) {
    return fs.readFile(name, function(err, src) {
      if (err) return cb(err);
      return cb(false, parse(src));
    });
  };

  toJSON = function(src, replacer, spacer) {
    return JSON.stringify(parse(src), replacer, spacer);
  };

  toJSON.pretty = function(src, replacer) {
    return toJSON(src, replacer, 2);
  };

  fileToJSON = function() {
    var args, cb, name, _i;
    name = arguments[0], args = 3 <= arguments.length ? __slice.call(arguments, 1, _i = arguments.length - 1) : (_i = 1, []), cb = arguments[_i++];
    fs.readFile(name, function(err, src) {
      if (cb) {
        if (err) return cb(err);
        return cb(false, toJSON.apply(null, [src].concat(__slice.call(args))));
      }
    });
  };

  fileToJSON.pretty = function(name, cb) {
    return fileToJSON(name, null, 2, cb);
  };

  convertFile = function() {
    var args, cb, name, _i;
    name = arguments[0], args = 3 <= arguments.length ? __slice.call(arguments, 1, _i = arguments.length - 1) : (_i = 1, []), cb = arguments[_i++];
    fileToJSON.apply(null, [name].concat(__slice.call(args), [function(err, json) {
      return fs.writeFile(name.replace(/\.coffeeson$/, '.json'), json, function(err) {
        if (cb) {
          if (err) return cb(err);
          return cb(false, json);
        }
      });
    }]));
  };

  convertFile.pretty = function(name, cb) {
    return convertFile(name, null, 2, cb);
  };

  module.exports = {
    parse: parse,
    parseFile: parseFile,
    toJSON: toJSON,
    fileToJSON: fileToJSON,
    convertFile: convertFile
  };

}).call(this);

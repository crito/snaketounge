fs              = require('fs')
{join,basename} = require('path')

redis  = require('redis')
Q      = require('q')

utils = require('../lib/utils')

exports.create = (req, res) ->
  utils.handleUpload(req.files.myfile)
    .then(utils.popAndPush)
    .then((file) -> res.send(JSON.stringify(file)))

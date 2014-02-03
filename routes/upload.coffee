fs              = require('fs')
{join,basename} = require('path')

redis  = require('redis')
Q      = require('q')

utils = require('../lib/utils')

handleError = (res) ->
  -> res.send(500, 'something blew up')

exports.create = (req, res) ->
  err = handleError(res)

  utils.handleUpload(req.files.myfile, err)
    .then(utils.popAndPush, err)
    .done((file) -> res.send(JSON.stringify(file)))

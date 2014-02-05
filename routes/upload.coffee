_ = require('lodash')

utils   = require('../lib/utils')
helpers = require('../lib/helpers')

exports.create = (req, res) ->
  file = _.pick(req.files.myfile, 'size', 'type', 'name', 'path')

  if file.size > require('config').maxUploadSize
    res.send(413, 'Request Entity Too Large')
    utils.incrementMetric("snaketounge.failed_uploads")
  else
    helpers.storeUpload(file)
      .then((file) -> helpers.pushAndPopFile(file))
      .done(
        (file) ->
          res.send(JSON.stringify(file))
          utils.incrementMetric("snaketounge.uploads")
        (reason) ->
          res.send(500, {error: reason.message})
          utils.incrementMetric("snaketounge.failed_uploads"))

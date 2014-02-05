_ = require('lodash')

utils   = require('../lib/utils')
helpers = require('../lib/helpers')

exports.create = (req, res) ->
  file = _.pick(req.files.myfile, 'size', 'type', 'name', 'path')

  helpers.enforceUploadLimit(file)
    .then((file) -> helpers.storeUpload(file))
    .then((file) -> helpers.pushAndPopFile(file))
    .done(
      (data) ->
        res.send(JSON.stringify(data))
        utils.trackMetric("snaketounge.uploads")
      (reason) ->
        res.send(500, {error: reason.message})
        utils.trackMetric("snaketounge.failed_uploads"))

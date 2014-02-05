_ = require('lodash')

utils   = require('../lib/utils')
helpers = require('../lib/helpers')

exports.create = (req, res) ->
  file = _.pick(req.files.myfile, 'size', 'type', 'name', 'path')

  helpers.enforceUploadLimit(file)
    .then((file) -> helpers.handleUpload(file))
    .then((file) -> helpers.pushAndPopFile(file))
    .then(utils.responseWithSuccess(res), utils.responseWithError(res))
    .done(
      helpers.trackMetric("snaketounge.uploads"),
      helpers.trackMetric("snaketounge.failed_uploads"))

_ = require('lodash')

utils   = require('../lib/utils')
helpers = require('../lib/helpers')

exports.create = (req, res) ->
  file = _.pick(req.files.myfile, 'size', 'type', 'name', 'path')

  helpers.enforceUploadLimit(file)
    .then((file) -> helpers.handleUpload(file))
    .then((file) -> helpers.pushAndPopFile(file))
    .done(utils.responseWithSuccess(res), utils.responseWithError(res))

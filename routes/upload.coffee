utils   = require('../lib/utils')
helpers = require('../lib/helpers')

exports.create = (req, res) ->
  helpers.handleUpload(req.files.myfile)
    .then(helpers.popAndPush)
    .catch(utils.logPromiseFailure)
    .then((file) -> res.send(JSON.stringify(file)))
    .catch(utils.handleError(res))

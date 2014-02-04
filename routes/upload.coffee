utils   = require('../lib/utils')
helpers = require('../lib/helpers')

exports.create = (req, res) ->
  helpers.handleUpload(req.files.myfile)
    .then(utils.popAndPush)
    .then((file) -> res.send(JSON.stringify(file)))
    .catch(utils.handleError(res))

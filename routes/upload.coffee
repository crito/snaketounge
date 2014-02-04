utils = require('../lib/utils')
store = require('../lib/storage')

exports.create = (req, res) ->
  store(req.files.myfile)
    .then(utils.popAndPush)
    .then((file) -> res.send(JSON.stringify(file)))
    .catch(utils.handleError(res))

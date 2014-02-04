mime = require('mime')
Q    = require('q')

utils   = require('./utils')
{store} = require('./storage')

handleUpload = (file) ->
  fileType = mime.lookup(file.path)
  deferred = Q.defer()

  store(file)
    .catch(utils.logPromiseFailure)
    .done((newPath) ->
      deferred.resolve(
        path: newPath
        mime: fileType
        name: file.originalFilename))
  deferred.promise

module.exports =
  handleUpload: handleUpload

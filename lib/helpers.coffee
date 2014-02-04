mime = require('mime')
Q    = require('q')

utils      = require('./utils')
{store}    = require('./storage')
{pop,push} = require('./queue')

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

# Pop and push files to the queue
popAndPush = (pushFile) ->
  deferred = Q.defer()
  pushFile = JSON.stringify(pushFile)
  
  {activeQueue,purgeQueue} = require('config').redis

  #FIXME: Add error handler to promise chain
  pop(activeQueue)
    .then((popFile) ->
      Q.all([
        push(purgeQueue, popFile),
        push(activeQueue, pushFile)
      ]).then(-> deferred.resolve(JSON.parse(popFile))))

  deferred.promise

module.exports =
  handleUpload: handleUpload
  popAndPush: popAndPush

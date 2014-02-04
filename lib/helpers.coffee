mime = require('mime')
Q    = require('q')
_    = require('lodash')

utils            = require('./utils')
{store,purge}    = require('./storage')
{pop,push,empty} = require('./queue')

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
      
# Remove stale uploads from the purge queue and the remote storage
purgeQueue = (queue) ->
  purgeOrRequeue = (file) ->
    console.log("Purge #{file.path}")
    purge(file.path)
      .fail(->
        # FIXME: The requeueing isn't yet tested
        push(purgeQueue, JSON.stringify(file)))

  empty(queue)
    .then((elems) ->
      Q.allSettled(_.map(elems, (file) -> purgeOrRequeue(file))))

module.exports =
  handleUpload: handleUpload
  popAndPush: popAndPush
  purgeQueue: purgeQueue

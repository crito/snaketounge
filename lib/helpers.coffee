Q       = require('q')
_       = require('lodash')

storage = require('./storage')
queue   = require('./queue')

# Store an uploaded file
storeUpload = (file) ->
  deferred = Q.defer()

  storage.store(file)
    .done((newPath) ->
      file.path = newPath
      deferred.resolve(file))
  deferred.promise

# Pop and push files to the queue.
pushAndPopFile = (pushFile) ->
  deferred = Q.defer()
  
  queue.update(pushFile)
    .done((popFile) -> deferred.resolve(popFile))
  deferred.promise
      
# Remove stale uploads from the purge queue and the remote storage
cleanQueue = ->
  queue.cleanup()
    .done((elems) ->
      Q.allSettled(_.map(elems, (file) -> storage.purge(file.path))))

module.exports =
  storeUpload:    storeUpload
  pushAndPopFile: pushAndPopFile
  cleanQueue:     cleanQueue

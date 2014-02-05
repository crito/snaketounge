Q       = require('q')
_       = require('lodash')

storage = require('./storage')
queue   = require('./queue')
  
# Refuse files that are too big
enforceUploadLimit = (file) ->
  deferred = Q.defer()

  if storage.isAllowedSize(file.size)
    deferred.resolve(file)
  else
     deferred.reject(new Error('File is too big'))
  deferred.promise

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
  enforceUploadLimit: enforceUploadLimit
  storeUpload:        storeUpload
  pushAndPopFile:     pushAndPopFile
  cleanQueue:         cleanQueue

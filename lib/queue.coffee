redis = require('redis')
Q     = require('q')
_     = require('lodash')

redisClient = ->
  cfg = require('config').redis
  opts = [cfg.port, cfg.host]
  if cfg.auth then opts.push({auth_pass: cfg.auth})
  client = redis.createClient.apply(null, opts)

  redisClient = -> client
  redisClient()

push = (queue, data) ->
  Q.ninvoke(redisClient(), "lpush", queue, data)

pop = (queue) ->
  Q.ninvoke(redisClient(), "rpop", queue)

# Push a new file to the queue and return a file from the queue
updateQueue = (pushFile) ->
  pushFile = JSON.stringify(pushFile)
  {activeQueue,purgeQueue} = require('config').redis

  pop(activeQueue)
    .then((popFile) ->
      Q.all([
        push(purgeQueue, popFile),
        push(activeQueue, pushFile)])
      .then(-> JSON.parse(popFile)))
  
clearQueue = (queue) ->
  deferred = Q.defer()
  multi = redisClient().multi([
    ["lrange", queue, 0, -1],
    ["del", queue]])

  Q.ninvoke(multi, "exec")
    .done((replies) ->
      deferred.resolve(_.map replies[0], (e) -> JSON.parse(e)))
  deferred.promise

clearPurgeQueue = clearQueue.bind(require('config').redis.purgeQueue)
              
module.exports =
  update:  updateQueue
  cleanup: clearPurgeQueue

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

empty = (queue) ->
  deferred = Q.defer()
  multi = redisClient().multi([
    ["lrange", queue, 0, -1]
    #["del", queue]
  ])

  Q.ninvoke(multi, "exec")
    .done((replies) ->
      deferred.resolve(_.map replies[0], (e) -> JSON.parse(e)))

  deferred.promise
              
module.exports =
  push: push
  pop: pop
  empty: empty

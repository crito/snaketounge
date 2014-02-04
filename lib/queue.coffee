redis = require('redis')
Q     = require('q')

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

module.exports =
  push: push
  pop: pop

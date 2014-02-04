crypto = require('crypto')

Q     = require('q')
redis = require('redis')

handleError = (res) ->
  -> res.send(500, 'something blew up')

createRedisClient = () ->
  cfg = require('config').redis
  opts = [cfg.port, cfg.host]
  if cfg.auth then opts.push({auth_pass: cfg.auth})
  redis.createClient.apply(null, opts)

# Return a random hex string
randomHexString = ->
  seed = crypto.randomBytes(20)
  crypto.createHash('sha1').update(seed).digest('hex')

# Log the reason if a promise fails
logPromiseFailure = (reason) ->
  console.log(reason)

# Pop and push files to the queue
popAndPush = (pushFile) ->
  deferred = Q.defer()
  client   = createRedisClient()
  pushFile = JSON.stringify(pushFile)

  #FIXME: Add error handler to promise chain
  Q.ninvoke(client, "rpop", "files")
    .then((popFile) ->
       Q.ninvoke(client, "lpush", "files", pushFile)
         .then(-> deferred.resolve(JSON.parse(popFile))))
  deferred.promise

module.exports =
  handleError: handleError
  randomHexString: randomHexString
  popAndPush: popAndPush
  logPromiseFailure: logPromiseFailure

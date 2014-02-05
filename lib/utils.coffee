crypto  = require('crypto')
librato = require('librato-node')

responseWithSuccess = (res) ->
  (data) -> res.send(JSON.stringify(data))

responseWithError = (res) ->
  (reason) -> res.send(500, {error: reason.message})

# Do some tracking
incrementMetric = (metric) ->
  if process.env.NODE_ENV == 'production'
    librato.increment metric

# Return a random hex string
randomHexString = ->
  seed = crypto.randomBytes(20)
  crypto.createHash('sha1').update(seed).digest('hex')

# Log the reason if a promise fails
logPromiseFailure = console.log

module.exports =
  incrementMetric:     incrementMetric
  responseWithError:   responseWithError
  responseWithSuccess: responseWithSuccess
  randomHexString:     randomHexString
  logPromiseFailure:   logPromiseFailure

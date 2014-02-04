crypto = require('crypto')

Q     = require('q')

handleError = (res) ->
  -> res.send(500, 'something blew up')

# Return a random hex string
randomHexString = ->
  seed = crypto.randomBytes(20)
  crypto.createHash('sha1').update(seed).digest('hex')

# Log the reason if a promise fails
logPromiseFailure = (reason) ->
  console.log(reason)

module.exports =
  handleError: handleError
  randomHexString: randomHexString
  logPromiseFailure: logPromiseFailure

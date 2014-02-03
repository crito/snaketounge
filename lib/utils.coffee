fs              = require('fs')
crypto          = require('crypto')
{join,basename} = require('path')

Q     = require('q')
mime  = require('mime')
redis = require('redis')

moveFile = Q.denodeify(fs.rename)

# Return a random hex string
randomHexString = ->
  seed = crypto.randomBytes(20)
  crypto.createHash('sha1').update(seed).digest('hex')

# Move an uploaded file to its correct place with a unique name.
# Returns a promise, that gets resolved with the new file location and mime
# type.
handleUpload = (file) ->
  fileType = mime.lookup(file.path)
  newPath  = join(process.cwd(), 'uploads', randomHexString())
  defer    = Q.defer()

  moveFile(file.path, newPath)
    .then(-> defer.resolve(
      path: newPath
      mime: fileType
      name: file.originalFilename))
    
  defer.promise

# Pop and push files to the queue
popAndPush = (pushFile) ->
  defer = Q.defer()
  client = redis.createClient()
  
  Q.ninvoke(client, "rpop", "files")
    .then((popFile) ->
       Q.ninvoke(client, "lpush", "files", JSON.stringify(pushFile))
        .then(-> defer.resolve(JSON.parse(popFile))))
  defer.promise

module.exports =
  handleUpload: handleUpload
  popAndPush: popAndPush

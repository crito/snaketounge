fs              = require('fs')
crypto          = require('crypto')
{join,basename} = require('path')

Q     = require('q')
mime  = require('mime')
redis = require('redis')

createRedisClient = () ->
  cfg = require('config').redis
  opts = [cfg.port, cfg.host]
  if cfg.auth then opts.push({auth_pass: cfg.auth})
  redis.createClient.apply(null, opts)

moveFile = Q.denodeify(fs.rename)
ensureDir = Q.denodeify(require('mkdirp'))

# Return a random hex string
randomHexString = ->
  seed = crypto.randomBytes(20)
  crypto.createHash('sha1').update(seed).digest('hex')

# Move an uploaded file to its correct place with a unique name.
# Returns a promise, that gets resolved with the new file location and mime
# type.
handleUpload = (file) ->
  {upload_dir} = require('config')
  fileType = mime.lookup(file.path)
  newPath  = join(upload_dir, randomHexString())
  defer    = Q.defer()

  ensureDir(upload_dir)
    .then(-> moveFile(file.path, newPath))
    .then(->
      defer.resolve(
        path: newPath
        mime: fileType
        name: file.originalFilename))
  defer.promise

# Pop and push files to the queue
popAndPush = (pushFile) ->
  defer = Q.defer()
  client = createRedisClient()
  pushFile = JSON.stringify(pushFile)

  Q.ninvoke(client, "rpop", "files")
    .then((popFile) -> Q.ninvoke(client, "lpush", "files", pushFile)
      .then(-> defer.resolve(JSON.parse(popFile))))
  defer.promise

module.exports =
  handleUpload: handleUpload
  popAndPush: popAndPush

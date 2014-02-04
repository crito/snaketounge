fs              = require('fs')
{join,basename} = require('path')

mime = require('mime')
Q    = require('q')
knox = require('knox')

utils = require('./utils')

storeRemote = (file) ->
  cfg = require('config').s3

  client = knox.createClient(
    key: cfg.key
    secret: cfg.secret
    bucket: cfg.bucket
    region: cfg.region)

  putFile = Q.nbind(client.putFile, client)
  newPath = join(utils.randomHexString(), file.originalFilename)
  s3Options = {'x-amz-acl': 'public-read'}

  putFile(file.path, newPath, s3Options)
    .then(-> client.url(newPath))
  
storeLocal = (file) ->
  moveFile  = Q.denodeify(fs.rename)
  ensureDir = Q.denodeify(require('mkdirp'))

  uploadDir = join(require('config').uploadDir, utils.randomHexString())
  newPath  = join(uploadDir, file.originalFilename)

  ensureDir(uploadDir)
    .then(-> moveFile(file.path, newPath))
    .then(-> newPath)

handleUpload = (file) ->
  fileType = mime.lookup(file.path)
  deferred = Q.defer()

  if process.env.NODE_ENV == 'production'
    store = storeRemote
  else
    store = storeLocal
    
  store(file)
    .catch(utils.logPromiseFailure)
    .done((newPath) ->
      console.log(newPath)
      deferred.resolve(
        path: newPath
        mime: fileType
        name: file.originalFilename))
  deferred.promise

module.exports = handleUpload

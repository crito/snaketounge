fs     = require('fs')
{join} = require('path')

Q    = require('q')
knox = require('knox')

utils = require('./utils')

s3StorageClient = () ->
  cfg = require('config').s3

  knox.createClient(
    key:    cfg.key
    secret: cfg.secret
    bucket: cfg.bucket
    region: cfg.region)

storeRemote = (file) ->
  client  = s3StorageClient()
  putFile = Q.nbind(client.putFile, client)
  newPath = join(utils.randomHexString(), file.originalFilename)
  options = {'x-amz-acl': 'public-read'}

  putFile(file.path, newPath, options)
    .then(-> client.url(newPath))
  
storeLocal = (file) ->
  moveFile  = Q.denodeify(fs.rename)
  ensureDir = Q.denodeify(require('mkdirp'))
  uploadDir = join(require('config').uploadDir, utils.randomHexString())
  newPath   = join(uploadDir, file.originalFilename)

  ensureDir(uploadDir)
    .then(-> moveFile(file.path, newPath))
    .then(-> newPath)
  
purge = (file) ->
  client     = s3StorageClient()
  deleteFile = Q.nbind(client.deleteFile, client)

  deleteFile(require('url').parse(file))

module.exports =
  store: if process.env.NODE_ENV == 'production' then storeRemote else storeLocal
  purge: purge

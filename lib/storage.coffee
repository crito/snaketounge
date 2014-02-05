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

isAllowedSize = (size) ->
  if size > require('config').maxUploadSize then false else true

storeRemote = (file) ->
  client  = s3StorageClient()
  putFile = Q.nbind(client.putFile, client)
  newPath = join(utils.randomHexString(), file.name)
  options = {'x-amz-acl': 'public-read'}

  putFile(file.path, newPath, options)
    .then(-> client.url(newPath))
  
storeLocal = (file) ->
  moveFile   = Q.denodeify(fs.rename)
  ensureDir  = Q.denodeify(require('mkdirp'))
  uploadDir  = join(require('config').uploadDir, utils.randomHexString())
  newPath    = join(uploadDir, file.name)

  ensureDir(uploadDir)
    .then(-> moveFile(file.path, newPath))
    .then(-> newPath)
  
purgeRemote = (file) ->
  client = s3StorageClient()
  deleteFile = Q.nbind(client.deleteFile, client)
  
  deleteFile(require('url').parse(file).path)

module.exports =
  isAllowedSize: isAllowedSize
  store: if process.env.NODE_ENV in ['production', 'staging']
           storeRemote
         else
           storeLocal
  purge: purgeRemote

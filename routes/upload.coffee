fs              = require('fs')
{join,basename} = require('path')

redis  = require('redis')
Q      = require('q')

moveFile    = Q.denodeify(fs.rename)
failRequest = -> res.send

exports.create = (req, res) ->
  newPath = join(process.cwd(), 'uploads', req.files.myfile.originalFilename)
  client  = redis.createClient()

  moveFile(req.files.myfile.path, newPath)
    .then((-> Q.ninvoke(client, "rpop", "files")), failRequest)
    .then((path) ->
      Q.ninvoke(client, "lpush", "files", newPath)
        .then(->
          res.send(JSON.stringify({path: "/download/#{basename(path)}"}))))

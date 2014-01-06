{readFile, writeFile} = require('fs')
{join}                = require('path')

exports.create = (req, res) ->
  # mkdir path
  readFile(req.files.myfile.path, (err, data) ->
    newPath = join(process.cwd(), 'uploads', req.files.myfile.originalFilename)
    console.log(newPath)
    writeFile(newPath, (err) ->
      res.redirect('')))

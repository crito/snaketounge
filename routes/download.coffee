{join} = require('path')

exports.show = (req, res) ->
  res.sendfile(join(process.cwd(), 'uploads', req.params.file))

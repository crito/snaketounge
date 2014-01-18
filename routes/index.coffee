upload   = require('./upload')
download = require('./download')

module.exports = (app) ->
  app.post('/upload', upload.create)
  app.get('/download/:file', download.show)

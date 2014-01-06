upload = require('./upload')

module.exports = (app) ->
  app.post('/upload', upload.create)

$ = window.$
{View, Route} = require('./base')
{UploadForm} = require('./upload_form')

{wait} = require('../util')

# View
class App extends View
  elements:
    '.container': '$container'

  constructor: ->
    super

    @uploadForm = new UploadForm
    @uploadForm.$el.appendTo(@$el)

# Export
module.exports = {App}

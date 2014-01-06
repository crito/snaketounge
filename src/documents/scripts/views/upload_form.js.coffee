$ = window.$
{View, Route} = require('./base')

# View
class UploadForm extends View
  el: $('.upload-form').remove().first().prop('outerHTML')

  elements:
    'form': '$upload-form'

  events:
    'change input': 'fileSelected'
    'click input[type=button]': 'startUploading'

  fileSelected: ->
    console.log('File selected.')

  startUploading: ->
    console.log('Start Uploading')

# Export
module.exports = {UploadForm}

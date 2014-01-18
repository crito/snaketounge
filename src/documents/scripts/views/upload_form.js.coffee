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
    formData = new FormData(@$el.find('form')[0])
    #request  = new XMLHttpRequest

    #request.open("POST", "/upload")
    #request.send(formData)
    #console.log('Start Uploading.')
    
    $.ajax('/upload', {
      processData: false,
      contentType: false,
      type: 'POST',
      data: formData})
      .done((data) ->
        console.log typeof data
        window.location.replace(JSON.parse(data).path))

# Export
module.exports = {UploadForm}

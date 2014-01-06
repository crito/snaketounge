$ = window.$
{View, Route} = require('./base')

# View
class UploadForm extends View
  el: $('.upload_form').remove().first().prop('outerHTML')

  elements:
    'form': '$upload_form'

# Export
module.exports = {UploadForm}

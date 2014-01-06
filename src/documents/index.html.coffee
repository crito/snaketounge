---
layout: 'default'
title: 'Home'
---

aside '.app', -> \
div '.container', ->
  
aside '.upload_form-container', -> \
section '.upload_form', ->
  form enctype: "multipart/form-data", method: "post", action: "upload", ->
    div ->
      label for: "myfile", -> "Please select file"
      div ->
        input type: "file", name: "myfile", id: "myfile", onchange: "fileSelected();"
      div ->
        input type: "button", value: "Upload", onclick: "startUploading();"

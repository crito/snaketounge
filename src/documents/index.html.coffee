---
layout: 'default'
title: 'Home'
---

aside '.app', -> \
div '.container', ->
  
aside '.upload-form-container', -> \
section '.upload-form', ->
  form enctype: "multipart/form-data", method: "post", action: "upload", ->
    div ->
      label for: "myfile", -> "Please select file"
      div ->
        input type: "file", name: "myfile", id: "myfile"
      div ->
        input type: "button", value: "Upload"

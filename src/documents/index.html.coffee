---
layout: 'default'
title: 'Home'
---

div ->
  form id: "upload_form", enctype: "multipart/form-data", method: "post", action: "upload", ->
    div ->
      div ->
        label for: "myfile", ->
          "Please select file"
      div ->
        input type: "file", name: "myfile", id: "myfile", onchange: "fileSelected();"
      div ->
        input type: "button", value: "Upload", onclick: "startUploading();"

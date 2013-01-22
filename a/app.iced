pretty  = require('pretty-data').pd
express = require 'express'

# Middlware:
bufferer = (req, res, next) ->
  data = ''

  req.setEncoding 'utf8'
  req.on 'data', (x) -> data += x;
  req.on 'end' , ->
    req.body = data
    next() # Call the next request handler

# Application description:
app = express()

app.use express.limit '2mb'
app.use bufferer

# With that set, we'll just buffer requests

app.post '/xml', (req, res) ->
  res.send pretty.xml req.body

app.post '/json', (req, res) ->
  res.send pretty.json req.body

app.post '/sql', (req, res) ->
  res.send pretty.sql req.body

app.post '/css', (req, res) ->
  res.send pretty.sql req.body

app.listen 8000

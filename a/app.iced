pretty  = require('pretty-data').pd
express = require 'express'

# Environment settings:
NODE_ENV  = process.env.NODE_ENV  ? 'development'
NODE_PORT = process.env.NODE_PORT ? 8000

# Other
DEFAULT_ERROR = [500,
  "Something broke. Well, this is embarrasing. I'm sending myself an e-mail.\n"
]

# Helpers and idioms:
handle = (f) -> (req, res) -> res.send 200, f(req)

# Middlware:
droproot = (req, res, next) ->
  # Before anything else is done, if we're root, we'll drop those priviledges.
  # Instead, we'll become the owner of this file.
  if process.getuid() == 0
    process.setuid require('fs').statSync(__filename).uid

  next()

bufferer = (req, res, next) ->
  # Buffer the request body into a string
  data = ''

  req.setEncoding 'utf8'
  req.on 'data', (x) -> data += x;
  req.on 'end' , ->
    req.body = data
    next()

catcher = (err, req, res, next) ->
  # Pretend we know what's going on when an exception reached us
  console.error err.stack
  res.send 500, { error: err.name, message: err.message }
  next()

# Application description:
app = express()

app.use droproot
app.use express.limit '2mb'
app.use bufferer
app.use app.router
app.use catcher

app.post '/xml' , handle (r) -> pretty.xml  r.body
app.post '/json', handle (r) -> pretty.json r.body
app.post '/sql' , handle (r) -> pretty.sql  r.body
app.post '/css' , handle (r) -> pretty.css  r.body

console.log "Starting #{NODE_ENV} server on port #{NODE_PORT}..."

app.listen NODE_PORT


DESTINATION_FOLDER = '/home/will/Music/downloads'

express = require('express')
bodyParser = require('body-parser')
cors = require('cors')

request = require('superagent')

fs = require('fs')

mmm = require('mmmagic')
magic = new mmm.Magic(mmm.MAGIC_MIME_TYPE)
libmime = require('libmime')

app = express()
app.use(bodyParser.json())
app.use(cors())

format = (path, cb) ->
  magic.detectFile(path, (err, result) ->
    if err then throw err
    extension = libmime.detectExtension(result)
    cb(extension)
  )

savefile = ({artist, name, url}, resp) ->
  filename = "#{name} -- #{artist}"
  dest = "#{DESTINATION_FOLDER}/#{filename}"

  console.log 'requesting', url
  request
    .get url
    .set('Accept-Encoding', 'gzip,deflate,sdch')
    .set('Connection', 'keep-alive')
    .end (err, res) ->
      if err or res.status > 399
        console.error res.status
        console.log('Error retrieving file')
        return resp.send('')
      res.pipe(fs.createWriteStream(dest))
      res.on 'end', ->
        format(dest, (ext) ->
          finalPath = "#{dest}.#{ext}"
          fs.rename(dest, finalPath, ->
            console.log "'#{filename}.#{ext}' <= '#{url}'"
            resp.send('')
          )
        )

app.post('/save', (req, resp) ->
  {artist, name, url} = req.body
  savefile({
    artist: artist
    name: name
    url: url
  }, resp)
)

app.listen 7777
console.log 'Listening on port 7777'

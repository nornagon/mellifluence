try
  context = new webkitAudioContext
catch e
  console.warn 'WebKit audio not supported in this browser'

sounds = {}

onError = (e) -> console.error e

load = (url, cb) ->
  request = new XMLHttpRequest()
  request.open('GET', url, true)
  request.responseType = 'arraybuffer'

  request.onload = ->
    context.decodeAudioData request.response, (buf) ->
      sounds[url] = buf
      cb(buf)
    , onError
  request.send()

play = (url, opts) ->
  unless buf = sounds[url]
    console.warn "tried to play sound #{url} without loading it"
  source = context.createBufferSource()
  source.buffer = sounds[url]
  gain = opts?.gain ? 1
  delay = opts?.delay ? 0
  if gain isnt 1
    gainNode = context.createGainNode()
    source.connect gainNode
    gainNode.connect context.destination
    gainNode.gain.value = gain
  else
    source.connect context.destination
  source.noteOn delay

window.sound = { load, play }

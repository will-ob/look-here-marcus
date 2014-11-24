App.Collections.Tracks.each(function(m){
  console.warn(m);
  jQuery.ajax({
    url: 'http://localhost:7777/save',
    type: "POST",
    contentType: "application/json",
    data: JSON.stringify({
      "artist": m.get('performer'),
      "name": m.get('name'),
      "url": m.get('track_file_stream_url')
    })
  })
})


App.Collections.Tracks.on('add', function(m){
  console.warn(m);
  jQuery.ajax({
    url: 'http://localhost:7777/save',
    type: "POST",
    contentType: "application/json",
    data: JSON.stringify({
      "artist": m.get('performer'),
      "name": m.get('name'),
      "url": m.get('track_file_stream_url')
    })
  })
})

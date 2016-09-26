$(document).on('click', '.player.play', function(e) {
  var that    = $(this),
      link    = that.siblings('.file').attr('href'),
      result  = that.closest('.result');

  e.preventDefault();

  if (result.hasClass('paused')) {
    window.player.play();
    result.removeClass('paused');
  } else {
    if (window.player != undefined) {
      $('.playing').removeClass('playing paused');
      window.player.stop();
    }

    window.player = AV.Player.fromURL(link);
    player.preload();

    player.on('ready', function() {
      // Aurora doesn't create the audio context until you start playing it.
      player.play();
      result.addClass('playing');
    });

    player.on('end', function() {
      result.removeClass('playing paused');
    });
  }

  // if (result.hasClass('playing'))
  //
  // if (that.hasClass('paused')) {
  //   player.play();
  //   that.siblings('.pause').removeClass('hide');
  //   that.addClass('hide');
  // }
  // else {
  //   $('.play.paused').removeClass('paused');
  //   $('.pause').addClass('hide');
  //   $('.play.hide').removeClass('hide');
  //
  //   if (window.player != undefined) {
  //     window.player.stop();
  //   }
  //
  //   // Load the FLAC file
  //   window.player = AV.Player.fromURL(link);
  //   player.preload();
  //
  //   player.on('ready', function () {
  //     // Aurora doesn't create the audio context until you start playing it.
  //     player.play();
  //     that.closest('.result').addClass('playing')
  //     that.siblings('.pause').removeClass('hide')
  //     that.addClass('hide')
  //   });
  // }
});

$(document).on('click', '.player.pause', function(e) {
  var that    = $(this),
      result  = that.closest('.result');

  e.preventDefault();

  if (window.player != undefined) {
    window.player.pause()
    result.addClass('paused')
  }
});

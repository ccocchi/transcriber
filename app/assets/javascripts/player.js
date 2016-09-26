$(document).on('click', '.player.play', function(e) {
  var that = $(this),
      link = that.siblings('.file').attr('href');

  e.preventDefault();

  if (that.hasClass('paused')) {
    player.play();
    that.siblings('.pause').removeClass('hide');
    that.addClass('hide');
  }
  else {
    $('.play.paused').removeClass('paused');
    $('.pause').addClass('hide');
    $('.play.hide').removeClass('hide');

    if (window.player != undefined) {
      window.player.stop();
    }

    // Load the FLAC file
    window.player = AV.Player.fromURL(link);
    player.preload();

    player.on('ready', function () {
      // Aurora doesn't create the audio context until you start playing it.
      player.play();
      that.siblings('.pause').removeClass('hide')
      that.addClass('hide')
    });
  }
});

$(document).on('click', '.player.pause', function(e) {
  var that = $(this);

  e.preventDefault();

  if (window.player != undefined) {
    window.player.pause()
    that.siblings('.play').removeClass('hide').addClass('paused')
    that.addClass('hide')
  }
});

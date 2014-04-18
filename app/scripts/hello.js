(function() {
  var attr, image, images, _i, _len;

  console.log('Handcrafted by Alonso Holmes, Ethan Sherr, and Matthew Kulp');

  mixpanel.track('Landing page loaded');

  mixpanel.track_links('.testflightLink', 'Beta link clicked');

  if (window.devicePixelRatio >= 1.2) {
    images = document.getElementsByTagName('img');
    for (_i = 0, _len = images.length; _i < _len; _i++) {
      image = images[_i];
      attr = image.getAttribute('data-2x');
      if (attr) {
        image.src = attr;
      }
    }
  }

}).call(this);

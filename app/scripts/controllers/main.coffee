'use strict'

angular.module('earshotApp')
  .controller 'MainCtrl', ($scope) ->

  	# Track the loaded event
  	mixpanel.track "Landing page loaded"

  	# Track the link clicks
  	mixpanel.track_links '.downloadLink', 'Download Link Clicked'
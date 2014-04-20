console.log 'Handcrafted by Alonso Holmes, Ethan Sherr, and Matthew Kulp'
# On launch, track the page load
mixpanel.track 'Landing page loaded'
# Track the beta link click
mixpanel.track_links '.testflightLink', 'Beta link clicked'
# Track the email link
mixpanel.track_links '.emailLink', 'Email link clicked'

# Replace all the normal images with retina images, if on a retina device
if window.devicePixelRatio >= 1.2
	images = document.getElementsByTagName 'img'
	for image in images
		attr = image.getAttribute 'data-2x'
		if attr
			image.src = attr


# Make a request to the imp to show the page loaded
$.get 'https://agent.electricimp.com/KIxBoMvUG2Vq/landing'

# When the testflightLink is clicked, send to the imp
$('.testflightLink').click ->
	$.get 'https://agent.electricimp.com/KIxBoMvUG2Vq/testflight'

# When the email is clicked, send to the imp
$('.emailLink').click ->
	$.get 'https://agent.electricimp.com/KIxBoMvUG2Vq/email'
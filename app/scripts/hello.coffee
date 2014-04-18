console.log 'Handcrafted by Alonso Holmes, Ethan Sherr, and Matthew Kulp'
# On launch, track the page load
mixpanel.track 'Landing page loaded'
# Track the beta link click
mixpanel.track_links '.testflightLink', 'Beta link clicked'

# Replace all the normal images with retina images, if on a retina device
if window.devicePixelRatio >= 1.2
	images = document.getElementsByTagName 'img'
	for image in images
		attr = image.getAttribute 'data-2x'
		if attr
			image.src = attr
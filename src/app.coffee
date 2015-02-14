CardGrabber = require './CardGrabber.coffee'
Classifier = require './Classifier.coffee'
Processor = require './Processor.coffee'

window.addEventListener "DOMContentLoaded", (->

	canvas = document.getElementById "canvas"
	# video = document.getElementById "video"

	window.cardImg = document.getElementById "cardImg"
	window.cardCanvas = document.getElementById "card"
	window.cardCanvas2 = document.getElementById "card2"
	window.grabbedCanvas = document.getElementById "grabbed"
	window.thresholdedCanvas = document.getElementById "thresholded"
	window.thinnedCanvas = document.getElementById "thinned"

	window.start = Date.now()

	setTimeout (->
		cardCanvas.getContext('2d').drawImage cardImg, 0, 0, 640, 480
		cardCanvas2.getContext('2d').drawImage cardImg, 0, 0, 128, 96
		processor = new Processor cardCanvas
	), 100
	# window.cardGrabber = new CardGrabber canvas, video, processor, 200
	
	window.gaussian = (s) -> (x, y) ->
		(1 / (2 * Math.PI * s**2)) * Math.exp(-(x**2 + y**2)/(2 * s**2))


), false

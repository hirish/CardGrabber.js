Image = require './Image.coffee'

module.exports = class Processor
	# offsetX: 90
	# offsetY: 100
	offsetX: 0
	offsetY: 480-290
	width: 480
	height: 290

	kernels:
		id: [[1]]
		edge: [ [-1, -2, -1], [-2, 12, -2], [-1, -2, -1], ]
		blur: [ [1, 1, 1], [1, 1, 1], [1, 1, 1], ]
		gx: [ [1, 0, -1], [2, 0, -2], [1, 0, -1], ]
		gy: [ [1, 2, 1], [0, 0, 0], [-1, -2, -1], ]

	constructor: (@canvas) ->
		@context = @canvas.getContext '2d'

		i1 = new Image @context.getImageData @offsetX, @offsetY, @width, @height
		i2 = new Image @context.getImageData @offsetX, @offsetY, @width, @height

		grabbedCanvas.getContext('2d').putImageData i1.imageData, 0, 0

		i1.filter @kernels.gx
		i2.filter @kernels.gy

		i1.add i2

		i1.threshold 50
		
		thresholdedCanvas.getContext('2d').putImageData i1.output(), 0, 0

		i1.thin()

		thinnedCanvas.getContext('2d').putImageData i1.output(), 0, 0

		console.info "Took", Date.now() - window.start

	neighbours: (image) ->
		(x, y) ->
			[
				image x-1, y-1
				image x, y-1
				image x+1, y-1
				image x-1, y
				image x+1, y
				image x-1, y+1
				image x, y+1
				image x+1, y+1
			]

	normalize: (min = 0, max = 255) ->
		max -= min
		(val) ->
			if val > max then val = max
			if val < min then val = min
			255 - Math.round(255 * ((val - min) / max))

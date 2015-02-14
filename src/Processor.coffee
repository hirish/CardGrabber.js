Image = require './Image.coffee'

module.exports = class Processor
	offsetX: 90
	offsetY: 100
	width: 480
	height: 290

	kernels:
		id: [[1]]
		edge: [ [-1, -2, -1], [-2, 12, -2], [-1, -2, -1], ]
		blur: [ [1, 1, 1], [1, 1, 1], [1, 1, 1], ]
		gx: [ [1, 0, -1], [2, 0, -2], [1, 0, -1], ]
		gy: [ [1, 2, 1], [0, 0, 0], [-1, -2, -1], ]
		gaussian: [ [1, 4, 7, 4, 1], [4, 16, 26, 16, 4], [7, 26,	41, 26, 7], [1, 4, 7, 4, 1], [4, 16, 26, 16, 4] ]
		gaussianX: (sigma, width=3) ->
			[(Math.exp(-(x**2)/(2 * sigma**2))/(sigma**2) for x in [-width..width])]
		gaussianY: (sigma, width=3) ->
			[Math.exp(-(x**2)/(2 * sigma**2))/(sigma**2)] for x in [-width..width]

	constructor: (@canvas) ->
		@context = @canvas.getContext '2d'

		id1 = @context.getImageData @offsetX, @offsetY, @width, @height
		id2 = @context.getImageData @offsetX, @offsetY, @width, @height

		i1 = @imageDataToImage id1
		i2 = @imageDataToImage id2

		@imageToImageData i1, id1
		grabbedCanvas.getContext('2d').putImageData id1, 0, 0
		console.info @kernels.gaussianY(1)

		console.info @kernels.gaussianX(1)
		console.info @kernels.gaussianX(50)

		i1.filter @kernels.gaussianY 1
		i2.filter @kernels.gaussian

		# i1.filter @kernels.gx
		# i2.filter @kernels.gy
    #
		# i1.add i2

		# i1.threshold 50
		
		@imageToImageData i1, id1
		thresholdedCanvas.getContext('2d').putImageData id1, 0, 0

		console.info "Took", Date.now() - window.start

	_coordsToIndex: (x, y) ->
		4 * ((y * @width) + x)

	imageDataToImage: (imageData, fn) ->
		if not fn then fn = (r,g,b) -> ~~((r+g+b)/3)

		data =
			for x in [0...imageData.width]
				for y in [0...imageData.height]
					i = @_coordsToIndex x, y
					fn imageData.data[i], imageData.data[i+1], imageData.data[i+2]

		new Image data, imageData.width, imageData.height

	imageToImageData: (image, imageData, fn) ->
		if not fn then fn = (v) -> [v,v,v]

		imageData.width = image.width
		imageData.height = image.height

		for x in [0...image.width]
			for y in [0...image.height]
				i = @_coordsToIndex x, y
				val = fn image.getPixel(x, y)
				imageData.data[i] = val[0]
				imageData.data[i+1] = val[1]
				imageData.data[i+2] = val[2]

		return imageData

module.exports = class Processor
	constructor: (@canvas) ->
		@context = @canvas.getContext '2d'

	_process: ->
		image = new Image @canvas, @context
		@process image

	process: (image) ->
		yellow = 'yellow'

		for x in [0...1]
			for y in [0...1]
				image.setPixel x, y, yellow
		
class Image
	constructor: (canvas, @context) ->
		@width = canvas.width
		@height = canvas.height
		# @data =	@context.getImageData 0, 0, @width, @height
		# @length = @data.length
	
	getPixel: (x, y) ->
		
		index = y * @width + x
		absIndex = 4 * index # Each pixel has 4 bytes

		@data[absIndex...(absIndex+4)]

	setPixel: (x, y, color) ->
		@context.fillStyle = color
		@context.rect x, y, 1, 1
		@context.fill()


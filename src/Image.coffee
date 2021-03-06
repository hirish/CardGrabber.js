module.exports = class Image
	constructor: (@data, @width, @height) ->
	
	getPixel: (x, y) ->
		@data[x][y]
	
	setPixel: (x, y, val) ->
		@data[x][y] = val

	filter: (kernel) ->
		M = kernel.length
		N = kernel[0].length

		flattened = kernel.reduce (x, y) -> x.concat(y)
		total = flattened.reduce (x, y) -> x + y
		multiplier = 1 / (total or 1)
		
		@data =
			for x in [0...@width]
				for y in [0...@height]
					if x < M or y < N then 0
					else
						sum = 0
						for m in [0...M]
							for n in [0...N]
								sum += kernel[m][n] * @getPixel(x-m, y-n)
						sum = ~~(sum * multiplier)
						Math.abs(sum)

	map: (fn) ->
		@data =
			for x in [0...@width]
				for y in [0...@height]
					fn @getPixel(x, y), x, y

	threshold: (threshold) ->
		@map (val) -> if val > threshold then 1 else 0

	add: (image) ->
		@map (v, x, y) -> v + image.getPixel x, y

	# Returns a list of neighbours, from above the position, then closewise around
	# until above-left of the position.
	# Padded with two empty neighbours before so indexes correspond to thinning
	# algorithm appropriately.
	neighbours: (x, y) ->
		[
			0
			0
			@getPixel x, y-1
			@getPixel x+1, y-1
			@getPixel x+1, y
			@getPixel x+1, y+1
			@getPixel x, y+1
			@getPixel x-1, y+1
			@getPixel x-1, y
			@getPixel x-1, y-1
		]

	# As taken from http://fourier.eng.hmc.edu/e161/lectures/morphology/node2.html
	thin: (iter = false)  ->
		toDelete = []

		for y in [1...@height-1]
			for x in [1...@width-1]
				if not @getPixel(x, y) then continue

				p = @neighbours x, y
				
				A = (not p[2] and p[3]) + (not p[3] and p[4]) +
						(not p[4] and p[5]) + (not p[5] and p[6]) +
						(not p[6] and p[7]) + (not p[7] and p[8]) +
						(not p[8] and p[9]) + (not p[9] and p[2])

				B = p.reduce (a,b) -> a+b

				m1 = if iter then p[2] * p[4] * p[6] else p[2] * p[4] * p[8]
				m2 = if iter then p[4] * p[6] * p[8] else p[2] * p[6] * p[8]

				if (A is 1) and ((B >= 2) and (B <=6)) and (not m1) and (not m2)
					toDelete.push([x,y])

		for [x,y] in toDelete
			@setPixel x, y, 0

		if toDelete.length
			@thin(not iter)

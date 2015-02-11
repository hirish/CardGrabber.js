module.exports = class CardGrabber
	constructor: (@canvas, @video, @processor, @timeout) ->
		@context = @canvas.getContext '2d'
		videoObj = video: true

		if navigator.getUserMedia
			navigator.getUserMedia videoObj, @initVideo, @error

		else if navigator.webkitGetUserMedia
			navigator.webkitGetUserMedia videoObj, ((stream) =>
				@initVideo window.webkitURL.createObjectURL stream
			), @error

		else if navigator.mozGetUserMedia
			navigator.mozGetUserMedia videoObj, ((stream) =>
				@initVideo window.URL.createObjectURL stream
			), @error

	error: (error) ->
		console.error "Video capture error:", error.code
		window.videoCaptureError = error

	initVideo: (stream) ->
		@video.src = stream
		@video.play()
		@interval = setInterval (=>
			@context.drawImage @video, 0, 0, 640, 480
			@processor._process()
		), @timeout

gulp = require 'gulp'
plugins = require 'gulp-load-plugins'

$ = plugins pattern: '*'

gulp.task 'coffee', ->
	gulp.src './src/app.coffee', read: false
		.pipe $.plumber()
		.pipe $.browserify
			transform: ['coffee-reactify']
		.pipe $.rename 'main.js'
		.pipe gulp.dest './public'

gulp.task 'coffee-watch', ->
	gulp.watch './src/**/*.coffee', ['coffee']
	gulp.watch './src/**/*.cjsx', ['coffee']

gulp.task 'default', ['coffee', 'coffee-watch']

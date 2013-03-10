#!
# Copyright (c) 2013 Alexander Aivars, Kramgo AB
# Licensed under the MIT license.
# 

"use strict"
module.exports = (grunt) ->
  # Project configuration.
  grunt.initConfig(
    sass:
      dist:
        options: # Target options
          style: "compressed"
          precision: "8"
        files: # Dictionary of files
          # 'destination': 'source'	
          "../public_html/css/main.css": "../src/sass/main.scss"
      dev: # Another target
        options: # Target options
          style: "expanded"
          precision: "8"
        files:
          "../public_html/css/main.css": "../src/sass/main.scss"
    
    coffee:
      source:
        expand: true
        cwd: "../src/coffee"
        src: ["*.coffee"]
        dest: "../public_html/js"
        ext: ".js"
    
    regarde:
      dist:
        files: "../public_html/**/*"
        tasks: ["livereload"]
      style:
        files: "../src/sass/**/*.scss"
        tasks: ["sass:dev"]
      code:
        files: "../src/coffee/**/*.coffee"
        tasks: ["coffee"]

    )
  
  # Load plugin task(s).
  grunt.loadNpmTasks "grunt-regarde"
  grunt.loadNpmTasks "grunt-contrib-sass"
  grunt.loadNpmTasks "grunt-contrib-connect"
  grunt.loadNpmTasks "grunt-contrib-coffee"
  grunt.loadNpmTasks "grunt-contrib-livereload"

  # grunt.loadNpmTasks "grunt-contrib-watch"
  # Register task(s).
  grunt.registerTask "default", ['sass:dev','coffee', 'livereload-start', 'regarde']

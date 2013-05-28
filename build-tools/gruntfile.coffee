#!
# Copyright (c) 2013 Alexander Aivars, Kramgo AB
# Licensed under the MIT license.
# 

"use strict"
module.exports = (grunt) ->
  # Project configuration.
  grunt.initConfig(
    pkg: grunt.file.readJSON('package.json')
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
    uglify:
      options:
        #except: ['jQuery', 'Backbone', 'TweenLite']
        mangle: true
        banner: '/*! Kramgo Tictail Theme - v<%= pkg.version %> - copyrightish (c) <%= grunt.template.today("yyyy-mm-dd") %> Alexander Aivars, Kramgo AB */'
      dist:
        files:
          "../public_html/js/dist/kramgo.min.js" : [ "../public_html/js/*.js" ]
      vendor:
        options:
          mangle: false
        files:
          "../public_html/js/dist/vendor-pack.min.js" : [ "../public_html/js/vendor/TweenLite.min.js",
                                                          "../public_html/js/vendor/CSSPlugin.min.js",
                                                          "../public_html/js/vendor/ScrollToPlugin.min.js",
                                                          "../public_html/js/vendor/polyfills.js",
                                                          "../public_html/js/vendor/jquery.hammer.js",
                                                          "../public_html/js/vendor/sammy-0.7.4.min.js"]
    includereplace:
      dist:
        options:
          includesDir: '../public_html'
        src: '../src/mustache/tictail.mustache'
        dest: '../dist'
      
    coffee:
      source:
        expand: true
        cwd: "../src/coffee"
        src: ["*.coffee"]
        dest: "../public_html/js"
        ext: ".js"
    
    regarde:
      # dist:
      #   files: "../public_html/**/*"
      #   tasks: ["livereload"]
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
  grunt.loadNpmTasks "grunt-contrib-uglify"
  grunt.loadNpmTasks "grunt-include-replace"

  # grunt.loadNpmTasks "grunt-contrib-watch"
  # Register task(s).
  grunt.registerTask "default", ['sass:dev','coffee', 'regarde']
  grunt.registerTask "dist", ['sass:dev','coffee', 'uglify', 'includereplace']
  # grunt.registerTask "default", ['sass:dev','coffee', 'livereload-start', 'regarde']

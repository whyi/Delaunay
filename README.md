# Incremental Delaunay Triangulation

## Introduction
This is an implementation of Incremental Delaunay Triangulation algorithm using processingjs.org

## How to compile/build/run
 * Grab the latest Processing from http://www.processing.org/
 * ```git clone https://github.com/whyi/Delaunay.git```
 * Open Delaunay.pde from Processing, it will load all the other files together.
 * Ctrl+R or [Sketch]-[Run In Browser] will bring this up!

## Unit testing
 * I have been using Jasmine and Coffeescript as the framework for unittest.
 * Have the app running via Processing, as described in the previous section.
 * Open a shell, execute runTests.sh
 * Now, navigate to http://127.0.0.1:RUNNING_PROCESISNG_PORT/SpecRunner.html within the browser where the RUNNING_PROCESSING_PORT is the port number of a running Processing instance. This will be provided when you run the app as described in the previous section.
 * Unable to run the unittests? See https://coderwall.com/p/t7zm7q/unittesting-processing-js-project-with-jasmine for more information.

## See it in action
The following page should give you the real-time demo in any webbrowser!
* http://www.whyi.net/geometry/Delaunay/

## Android version
I ported this over to Android and it's available to download
* Source Code : https://github.com/whyi/AndroidDelaunay
* Google Play Store : https://play.google.com/store/apps/details?id=processing.test.androiddelaunay
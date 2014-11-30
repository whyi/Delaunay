DEFAULT_LOAD_TIME_FOR_PROCESSINGJS = 100

prepareForProcessingJsTesting: -> true

beforeEach (prepareForProcessingJsTesting) ->
  setTimeout( ()->
    prepareForProcessingJsTesting()
  , DEFAULT_LOAD_TIME_FOR_PROCESSINGJS)

describe "OTableHelper", ->
  beforeEach ->
    @pjs = Processing.getInstanceById(getProcessingSketchId())
    @OTableHelper = @pjs.OTableHelper

  it "should support sorting", ->
    myOTableHelper = new @OTableHelper
    expect(myOTableHelper.naiveSort).toBeDefined()

  # FIXME : Cannot really call the method as it throws
  # Uncaught TypeError: undefined is not a function
DEFAULT_LOAD_TIME_FOR_PROCESSINGJS = 100

prepareForProcessingJsTesting: -> true

beforeEach (prepareForProcessingJsTesting) ->
  setTimeout( ()->
    prepareForProcessingJsTesting()
  , DEFAULT_LOAD_TIME_FOR_PROCESSINGJS)

describe "Vector2D", ->
  beforeEach ->
    @pjs = Processing.getInstanceById(getProcessingSketchId())
    @vector = @pjs.Vector2D

  it "can be constructed from two floats, say 10,10", ->
    v = new @vector(10,10)
    expect(v.x()).toBe(10)
    expect(v.y()).toBe(10)

  it "also can be constructed from two PVectors", ->
    pVector1 = new @pjs.PVector(10,10,10)
    pVector2 = new @pjs.PVector(100,100,10)
    newVector = new @vector(pVector1, pVector2)
    console.log("v here" + newVector.x())
    expect(newVector.x()).toBe(90)
    expect(newVector.y()).toBe(90)

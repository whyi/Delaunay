DEFAULT_LOAD_TIME_FOR_PROCESSINGJS = 100

prepareForProcessingJsTesting: -> true

beforeEach (prepareForProcessingJsTesting) ->
  setTimeout( ()->
    prepareForProcessingJsTesting()
  , DEFAULT_LOAD_TIME_FOR_PROCESSINGJS)

describe "GeometricOperations", ->
  beforeEach ->
    @pjs = Processing.getInstanceById(getProcessingSketchId())
    @GeometricOperations = new @pjs.GeometricOperations

  it "should compute circumcenter from three points", ->
    p1 = new @pjs.PVector(100,100,0)
    p2 = new @pjs.PVector(200,100,0)
    p3 = new @pjs.PVector(200,200,0)
    expectedCircumcenter = {x:150,y:150,z:0}
    expect(@GeometricOperations.circumcenter(p1, p2, p3)).toEqual(expectedCircumcenter)

  it "should tell if three points make a left-turn", ->
    p1 = new @pjs.PVector(100,100,0)
    p2 = new @pjs.PVector(200,100,0)
    p3 = new @pjs.PVector(200,200,0)
    p4 = new @pjs.PVector(300,200,0)
    expect(@GeometricOperations.isLeftTurn(p1, p2, p3)).toBe(true)
    expect(@GeometricOperations.isLeftTurn(p2, p3, p4)).toBe(false)
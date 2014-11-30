DEFAULT_LOAD_TIME_FOR_PROCESSINGJS = 100

prepareForProcessingJsTesting: -> true

beforeEach (prepareForProcessingJsTesting) ->
  setTimeout( ()->
    prepareForProcessingJsTesting()
  , DEFAULT_LOAD_TIME_FOR_PROCESSINGJS)

describe "Vector2D", ->
  beforeEach ->
    @pjs = Processing.getInstanceById(getProcessingSketchId())
    @Vector2D = @pjs.Vector2D
    @PVector = @pjs.PVector

  it "can be constructed from two PVectors", ->
    pVector1 = new @PVector(10,10,0)
    pVector2 = new @PVector(20,10,0)
    v = new @Vector2D(pVector1, pVector2)
    expect(v.x()).toBe(10)
    expect(v.y()).toBe(0)

  it "should be able to dot product", ->
    pVector1 = new @PVector(10,10,0)
    pVector2 = new @PVector(20,10,0)
    pVector3 = new @PVector(20,20,0)
    v1 = new @Vector2D(pVector1,pVector2)
    v2 = new @Vector2D(pVector1,pVector3)
    result = v1.dot(v2)
    expect(result).toBe(100)

  # FIXME : Figure out how to do numerical stress testing in Jasmine
  it "should be able to normalize itself", ->
    pVector1 = new @PVector(10,10,0)
    pVector2 = new @PVector(20,10,0)
    v = new @Vector2D(pVector1, pVector2)
    v.normalize()
    expect(v.x()).toBe(1)
    expect(v.y()).toBe(0)

  it "should be able to left turn", ->
    pVector1 = new @PVector(10,10,0)
    pVector2 = new @PVector(20,20,0)
    v = new @Vector2D(pVector1, pVector2)
    v.left()
    expect(v.x()).toBe(-10)
    expect(v.y()).toBe(10)

  it "should be able to scable by scalar", ->
    pVector1 = new @PVector(10,10,0)
    pVector2 = new @PVector(20,20,0)
    v = new @Vector2D(pVector1, pVector2)
    v.scaleBy(9999)
    expect(v.x()).toBe(99990)
    expect(v.y()).toBe(99990)
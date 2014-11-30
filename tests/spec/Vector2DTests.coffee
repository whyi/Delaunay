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

  it "can be constructed from two floats, say 10,10", ->
    v = new @Vector2D(10,10)
    expect(v.x()).toBe(10)
    expect(v.y()).toBe(10)

  it "should be able to dot product", ->
    v1 = new @Vector2D(100,100)
    v2 = new @Vector2D(1,0)
    result = v1.dot(v2)
    expect(result).toBe(100)

  # FIXME : Figure out how to do numerical stress testing in Jasmine
  it "should be able to normalize itself", ->
    v1 = new @Vector2D(100,0)
    v1.normalize()
    expect(v1.x()).toBe(1)
    expect(v1.y()).toBe(0)

  it "should be able to left turn", ->
    v = new @Vector2D(10,10)
    v.left()
    expect(v.x()).toBe(-10)
    expect(v.y()).toBe(10)

  it "should be able to scable by scalar", ->
    v = new @Vector2D(10,10)
    v.scaleBy(9999)
    expect(v.x()).toBe(99990)
    expect(v.y()).toBe(99990)
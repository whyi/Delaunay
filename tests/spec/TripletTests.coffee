DEFAULT_LOAD_TIME_FOR_PROCESSINGJS = 100

prepareForProcessingJsTesting: -> true

beforeEach (prepareForProcessingJsTesting) ->
  setTimeout( ()->
    prepareForProcessingJsTesting()
  , DEFAULT_LOAD_TIME_FOR_PROCESSINGJS)

describe "Triplet", ->
  beforeEach ->
    @pjs = Processing.getInstanceById(getProcessingSketchId())

  it "should support inequality", ->
    @triplet = new @pjs.Triplet(1,2,3)
    expect(@triplet.isLessThan).toBeDefined()

  describe "isLessThan", ->
    it "should return false when inequality is false", ->
      biggerTriplet = new @pjs.Triplet(2,2,2)
      smallerTriplet = new @pjs.Triplet(1,1,1)
      expect(biggerTriplet.isLessThan(smallerTriplet)).toBe(false)

    it "should return true when inequality is true", ->
      biggerTriplet = new @pjs.Triplet(2,2,2)
      smallerTriplet = new @pjs.Triplet(1,1,1)
      expect(smallerTriplet.isLessThan(biggerTriplet)).toBe(true)

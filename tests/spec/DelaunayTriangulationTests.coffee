DEFAULT_LOAD_TIME_FOR_PROCESSINGJS = 100

prepareForProcessingJsTesting: -> true

beforeEach (prepareForProcessingJsTesting) ->
  setTimeout( ()->
    prepareForProcessingJsTesting()
  , DEFAULT_LOAD_TIME_FOR_PROCESSINGJS)

describe "DelaunayTriangulation", ->
  beforeEach ->
    @pjs = Processing.getInstanceById(getProcessingSketchId())

  describe "addPoint", ->
    beforeEach ->
      @delaunayTriangulation = new @pjs.DelaunayTriangulation(800)

    it "should add a new point", ->
      expect(@delaunayTriangulation.numberOfVertices).toBe(4)
      @delaunayTriangulation.addPoint(10,20)
      expect(@delaunayTriangulation.numberOfVertices).toBe(5)

    it "should call fixMesh to clear out dirty corners", ->
      spyOn(@delaunayTriangulation, "fixMesh")
      @delaunayTriangulation.addPoint(10,20)
      expect(@delaunayTriangulation.fixMesh).toHaveBeenCalled()


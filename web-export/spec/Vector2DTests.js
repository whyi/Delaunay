(function() {
  var DEFAULT_LOAD_TIME_FOR_PROCESSINGJS;

  DEFAULT_LOAD_TIME_FOR_PROCESSINGJS = 100;

  ({
    prepareForProcessingJsTesting: function() {
      return true;
    }
  });

  beforeEach(function(prepareForProcessingJsTesting) {
    return setTimeout(function() {
      return prepareForProcessingJsTesting();
    }, DEFAULT_LOAD_TIME_FOR_PROCESSINGJS);
  });

  describe("Vector2D", function() {
    beforeEach(function() {
      this.pjs = Processing.getInstanceById(getProcessingSketchId());
      this.Vector2D = this.pjs.Vector2D;
      return this.PVector = this.pjs.PVector;
    });
    it("can be constructed from two PVectors", function() {
      var pVector1, pVector2, v;
      pVector1 = new this.PVector(10, 10, 0);
      pVector2 = new this.PVector(20, 10, 0);
      v = new this.Vector2D(pVector1, pVector2);
      expect(v.x()).toBe(10);
      return expect(v.y()).toBe(0);
    });
    it("should be able to dot product", function() {
      var pVector1, pVector2, pVector3, result, v1, v2;
      pVector1 = new this.PVector(10, 10, 0);
      pVector2 = new this.PVector(20, 10, 0);
      pVector3 = new this.PVector(20, 20, 0);
      v1 = new this.Vector2D(pVector1, pVector2);
      v2 = new this.Vector2D(pVector1, pVector3);
      result = v1.dot(v2);
      return expect(result).toBe(100);
    });
    it("should be able to normalize itself", function() {
      var pVector1, pVector2, v;
      pVector1 = new this.PVector(10, 10, 0);
      pVector2 = new this.PVector(20, 10, 0);
      v = new this.Vector2D(pVector1, pVector2);
      v.normalize();
      expect(v.x()).toBe(1);
      return expect(v.y()).toBe(0);
    });
    it("should be able to left turn", function() {
      var pVector1, pVector2, v;
      pVector1 = new this.PVector(10, 10, 0);
      pVector2 = new this.PVector(20, 20, 0);
      v = new this.Vector2D(pVector1, pVector2);
      v.left();
      expect(v.x()).toBe(-10);
      return expect(v.y()).toBe(10);
    });
    return it("should be able to scable by scalar", function() {
      var pVector1, pVector2, v;
      pVector1 = new this.PVector(10, 10, 0);
      pVector2 = new this.PVector(20, 20, 0);
      v = new this.Vector2D(pVector1, pVector2);
      v.scaleBy(9999);
      expect(v.x()).toBe(99990);
      return expect(v.y()).toBe(99990);
    });
  });

}).call(this);

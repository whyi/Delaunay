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
    it("can be constructed from two floats, say 10,10", function() {
      var v;
      v = new this.Vector2D(10, 10);
      expect(v.x()).toBe(10);
      return expect(v.y()).toBe(10);
    });
    it("should be able to dot product", function() {
      var result, v1, v2;
      v1 = new this.Vector2D(100, 100);
      v2 = new this.Vector2D(1, 0);
      result = v1.dot(v2);
      return expect(result).toBe(100);
    });
    it("should be able to normalize itself", function() {
      var v1;
      v1 = new this.Vector2D(100, 0);
      v1.normalize();
      expect(v1.x()).toBe(1);
      return expect(v1.y()).toBe(0);
    });
    it("should be able to left turn", function() {
      var v;
      v = new this.Vector2D(10, 10);
      v.left();
      expect(v.x()).toBe(-10);
      return expect(v.y()).toBe(10);
    });
    return it("should be able to scable by scalar", function() {
      var v;
      v = new this.Vector2D(10, 10);
      v.scaleBy(9999);
      expect(v.x()).toBe(99990);
      return expect(v.y()).toBe(99990);
    });
  });

}).call(this);

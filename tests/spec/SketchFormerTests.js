(function() {
  var DEFAULT_LOAD_TIME_FOR_PROCESSINGJS;

  DEFAULT_LOAD_TIME_FOR_PROCESSINGJS = 500;

  ({
    prepareForProcessingJsTesting: function() {
      return true;
    }
  });

  describe("SketchFormer", function() {
    beforeEach(function(prepareForProcessingJsTesting) {
      return setTimeout(function() {
        return prepareForProcessingJsTesting();
      }, DEFAULT_LOAD_TIME_FOR_PROCESSINGJS);
    });
    return describe("Mesh3D", function() {
      beforeEach(function() {
        this.pjs = Processing.getInstanceById(getProcessingSketchId());
        return this.mesh = this.pjs.getMesh();
      });
      it("should be able to load mesh file", function() {
        return expect(this.mesh.loadMesh).toBeDefined();
      });
      it("should be able to compute width", function() {
        return expect(this.mesh.width).toBeDefined();
      });
      it("should be able to compute height", function() {
        return expect(this.mesh.height).toBeDefined();
      });
      describe("given width and height are 100 respectively", function() {
        beforeEach(function() {
          spyOn(this.mesh, "width").and.returnValue(100);
          return spyOn(this.mesh, "height").and.returnValue(100);
        });
        return describe("when diag()", function() {
          beforeEach(function() {
            return this.returnedDiag = this.mesh.diag();
          });
          return it("should return 141.4213562373095", function() {
            return expect(this.returnedDiag).toBe(141.4213562373095);
          });
        });
      });
      return describe("when loadMesh()", function() {
        beforeEach(function() {
          spyOn(this.mesh, "computeBoundingBox");
          spyOn(this.mesh, "computeNormals");
          spyOn(this.mesh, "computeGeometricCenter");
          spyOn(this.mesh, "buildOTable");
          return this.mesh.loadMesh();
        });
        it("should read numberOfVertices", function() {
          return expect(this.mesh.numberOfVertices).toBe(102);
        });
        it("should read numberOfTriangles", function() {
          return expect(this.mesh.numberOfTriangles).toBe(200);
        });
        it("should read numberOfCorners", function() {
          return expect(this.mesh.numberOfCorners).toBe(600);
        });
        it("should compute bounding box", function() {
          return expect(this.mesh.computeBoundingBox).toHaveBeenCalled();
        });
        it("should compute GeometricCenter", function() {
          return expect(this.mesh.computeGeometricCenter).toHaveBeenCalled();
        });
        it("should compute normals", function() {
          return expect(this.mesh.computeNormals).toHaveBeenCalled();
        });
        it("should build OTable", function() {
          return expect(this.mesh.buildOTable).toHaveBeenCalled();
        });
        return it("should mark the mesh as loaded", function() {
          return expect(this.mesh.loaded).toBe(true);
        });
      });
    });
  });

}).call(this);

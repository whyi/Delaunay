(function() {
  var DEFAULT_LOAD_TIME_FOR_PROCESSINGJS;

  DEFAULT_LOAD_TIME_FOR_PROCESSINGJS = 100;

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
    describe("Mesh3D", function() {
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
      describe("when loadMesh()", function() {
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
      return describe("splitEdges", function() {
        beforeEach(function() {
          spyOn(this.mesh, "isBorder").and.callThrough();
          spyOn(this.mesh, "o").and.callThrough();
          this.mesh.loadMesh();
          this.previousNumberOfVertices = this.mesh.numberOfVertices;
          return this.mesh.splitEdges();
        });
        it("should check whether a corner is border or not", function() {
          return expect(this.mesh.isBorder).toHaveBeenCalled();
        });
        it("should check whether a corner has been seen or not", function() {
          return expect(this.mesh.o).toHaveBeenCalled();
        });
        return it("should increase the # of vertices by 4 minus # of boundries", function() {
          return expect(this.mesh.numberOfVertices).toBe(402);
        });
      });
    });
    describe("GeometricOperations", function() {
      beforeEach(function() {
        this.pjs = Processing.getInstanceById(getProcessingSketchId());
        return this.geometricOpertaions = this.pjs.getGeometricOperations();
      });
      describe("midPt", function() {
        return it("should return mid point of two PVectors", function() {
          var midPoint, pointA, pointB;
          pointA = {
            x: 10,
            y: 10,
            z: 10
          };
          pointB = {
            x: 20,
            y: 20,
            z: 20
          };
          midPoint = {
            x: 15,
            y: 15,
            z: 15
          };
          return expect(this.geometricOpertaions.midPt(pointA, pointB)).toEqual(midPoint);
        });
      });
      describe("vector", function() {
        return it("should compute and return a vector of two points", function() {
          var pointA, pointB, vectorAB;
          pointA = {
            x: 10,
            y: 10,
            z: 10
          };
          pointB = {
            x: 20,
            y: 20,
            z: 20
          };
          vectorAB = {
            x: 10,
            y: 10,
            z: 10
          };
          return expect(this.geometricOpertaions.vector(pointA, pointB)).toEqual(vectorAB);
        });
      });
      return describe("triNormal", function() {
        return it("should compute and return a normalized normal vector", function() {
          var expectedNormal, pointA, pointB, pointC;
          pointA = {
            x: 0,
            y: 0,
            z: 0
          };
          pointB = {
            x: 10,
            y: 0,
            z: 0
          };
          pointC = {
            x: 10,
            y: 10,
            z: 0
          };
          expectedNormal = {
            x: 0,
            y: 0,
            z: 1
          };
          return expect(this.geometricOpertaions.triNormal(pointA, pointB, pointC)).toEqual(expectedNormal);
        });
      });
    });
    describe("Triplet", function() {
      beforeEach(function() {
        return this.pjs = Processing.getInstanceById(getProcessingSketchId());
      });
      it("should support inequality", function() {
        this.triplet = new this.pjs.Triplet(1, 2, 3);
        return expect(this.triplet.isLessThan).toBeDefined();
      });
      return describe("isLessThan", function() {
        it("should return false when inequality is false", function() {
          var biggerTriplet, smallerTriplet;
          biggerTriplet = new this.pjs.Triplet(2, 2, 2);
          smallerTriplet = new this.pjs.Triplet(1, 1, 1);
          return expect(biggerTriplet.isLessThan(smallerTriplet)).toBe(false);
        });
        return it("should return true when inequality is true", function() {
          var biggerTriplet, smallerTriplet;
          biggerTriplet = new this.pjs.Triplet(2, 2, 2);
          smallerTriplet = new this.pjs.Triplet(1, 1, 1);
          return expect(smallerTriplet.isLessThan(biggerTriplet)).toBe(true);
        });
      });
    });
    return describe("OTableHelper", function() {
      beforeEach(function() {
        this.pjs = Processing.getInstanceById(getProcessingSketchId());
        return this.OTableHelper = this.pjs.getOTableHelper();
      });
      return it("should support sorting", function() {
        return expect(this.OTableHelper.naiveSort).toBeDefined();
      });

      /*
      describe "naiveSort", ->
        it "should be able to sort Triplets", ->
          sortedTriplets = []
          for i in [0..10] by 1
            sortedTriplets.push(new @pjs.Triplet(i,i,i))
      
          unsortedTriplets = sortedTriplets.reverse()
          @OTableHelper.naitveSort(unsortedTriplets)
          expect(true).toBe(false)
       */
    });
  });

}).call(this);

public class DelaunayTriangulation extends Mesh2D {
  // circumcircles
  private ArrayList circumcenters = new ArrayList();
  private ArrayList circumcircleRadius = new ArrayList();
  private boolean hasCircumcircles = false;

  public DelaunayTriangulation(int screenSize) {
    initTriangles(screenSize);
  }

  private void initTriangles(int screenSize) {
    vertices.add(new PVector(0,0));
    vertices.add(new PVector(0,screenSize));
    vertices.add(new PVector(screenSize, screenSize));
    vertices.add(new PVector(screenSize, 0));
  
    numberOfVertices = 4;
  
    corners.add(0);
    corners.add(1);
    corners.add(2);
    corners.add(2);
    corners.add(3);
    corners.add(0);

    numberOfTriangles = 2;
    numberOfCorners = 6;
  
    buildOTable();
  }

  private void computeCircumcenters() {
    hasCircumcircles = false;

    circumcenters = new ArrayList();
    circumcircleRadius = new ArrayList();
    for (int i = 0; i < numberOfTriangles; ++i) {
      int c = i*3;
      PVector circumcenter = geometricOperations.circumcenter(g(c),g(p(c)),g(n(c)));
      circumcenters.add(circumcenter);
      circumcircleRadius.add(PVector.dist(g(c), circumcenter));
    }

    hasCircumcircles = true;
  }

  private boolean naiveCheck(float radius, PVector circumcenter, int c) {
    return PVector.dist(g(c), circumcenter) > radius;
  }
  
  private boolean isDelaunay(int c) {
    // $$$FIXME : reuse precomputed cc and cr
    PVector circumcenter = geometricOperations.circumcenter(g(c),g(p(c)),g(n(c)));
    float radius = PVector.dist(g(c), circumcenter);
    return naiveCheck(radius, circumcenter, o(c));
  }
  
  private void flipCorner(int c) {
    if (c == BOUNDARY) {
      return;
    }
  
    buildOTable();    
  
    // boundary, do nothing..
    if (o(c) == BOUNDARY) {
      return;
    }
  
    if (!isDelaunay(c)) {
      int opp = o(c);
      
      corners.set(n(c), corners.get(opp));
      corners.set(n(opp), corners.get(c));
  
      buildOTable();
      flipCorner(c);
      buildOTable();
      flipCorner(n(opp));
    }
  }
  
  private void fixMesh(ArrayList l) {
    buildOTable();
  
    while (!l.isEmpty()) {
      final int c = (Integer)l.get(0);
      flipCorner(c);
      l.remove(0);
    }
  }
  
  private boolean isInTriangle(int triangleIndex, PVector P) {
    final int c = triangleIndex*3;
  
    PVector A = g(c);
    PVector B = g(n(c));
    PVector C = g(p(c));
  
    if (geometricOperations.isLeftTurn(A,B,P) == geometricOperations.isLeftTurn(B,C,P) &&
        geometricOperations.isLeftTurn(A,B,P) == geometricOperations.isLeftTurn(C,A,P)) {
      return true;
    }
  
    return false;
  }
  
  public void addPoint(final float x, final float y) {
    PVector newPoint = new PVector(x,y);
    vertices.add(newPoint);
    ++numberOfVertices;
  
    final int currentNumberOfTriangles = numberOfTriangles;
    for (int triangleIndex = 0; triangleIndex < currentNumberOfTriangles; ++triangleIndex) {
      if (isInTriangle(triangleIndex, newPoint)) {
        final int A = triangleIndex*3;
        final int B = A+1;
        final int C = A+2;
  
        corners.add(corners.get(B));
        corners.add(corners.get(C));
        corners.add(numberOfVertices-1);
  
        corners.add(corners.get(C));
        corners.add(corners.get(A));
        corners.add(numberOfVertices-1);
  
        corners.set(C, numberOfVertices-1);
        
        ArrayList dirtyCorners = new ArrayList();
        int dirtyCorner1 = C;
        int dirtyCorner2 = numberOfTriangles*3+2;
        int dirtyCorner3 = numberOfTriangles*3+5;
        dirtyCorners.add(dirtyCorner1);
        dirtyCorners.add(dirtyCorner2);
        dirtyCorners.add(dirtyCorner3);
  
        numberOfTriangles += 2;
        numberOfCorners += 6;
        fixMesh(dirtyCorners);
        break;
      }
    }
  }
  
  public void drawTriangles() {
    noFill();
    strokeWeight(1.0);
    stroke(0,255,0);
  
    for (int i = 0; i < numberOfTriangles; ++i) {
      int c = i*3;
      PVector A = g(c);
      PVector B = g(n(c));
      PVector C = g(p(c));
      triangle(A.x, A.y, B.x, B.y, C.x, C.y);
    }
  
    strokeWeight(5.0);
    for (int i = 0; i < numberOfVertices; ++i) {
      PVector p = (PVector) vertices.get(i);
      point(p.x, p.y);
    }
  }
  
  public void drawCircumcircles() {
    if (hasCircumcircles) {
      stroke(255,0,0);
      noFill();
      strokeWeight(1.0);
    
      for (int i = 3; i < numberOfTriangles; ++i) {
        stroke(0,0,255);
        fill(0,0,255);
        PVector circumcenter = (PVector) circumcenters.get(i);
        Float radius = (Float) circumcircleRadius.get(i)*2;
        ellipse(circumcenter.x, circumcenter.y, 5,5);
        stroke(255,0,0);
        noFill();  
        ellipse(circumcenter.x, circumcenter.y, radius, radius);
      }
        
      stroke(0,0,0);
      noFill();
    }
  }
}


public class DelaunayTriangulation {
  private final Mesh2D mesh;

  // corner table again!!
  public static final int MAX_STUFF = 6000;
  private int numberOfTriangles = 0;
  private int numberOfVertices = 0;
  private int numberOfCorners = 0;
  
  // circumcircles
  PVector[] circumcenters = new PVector[MAX_STUFF];
  float[] circumcircleRadius = new float[MAX_STUFF];
  boolean hasCircumcircles = false;

  // V Table
  private int[] V = new int[MAX_STUFF];
  private int[] C = new int[MAX_STUFF*3];
  
  // G Table
  private PVector[] G = new PVector[MAX_STUFF];
  
  // O-Table
  private int[] O = new int[MAX_STUFF];
  private OTableHelper myOTableHelper = new OTableHelper();
  private GeometricOperations geometricOperations = new GeometricOperations();

  public DelaunayTriangulation(int screenSize) {
    mesh = new Mesh2D();
    initTriangles(screenSize);
  }
  
  private int t(int idx) {
    return floor(idx/3);
  }
  
  private int v(int idx) {
    return V[idx];
  }
  
  private int o(int idx) {
    return O[idx];
  }
  
  private int n(int c) {
    if (c%3 == 2) {
      return c-2;
    }
  
    return c+1;
  }
  
  private int p(int c) {
    if (c%3 == 0) {
      return c+2;
    }
  
    return c-1;
  }
  
  private int g(final int triangleIndex) {
    return V[triangleIndex*3];
  }
  
  private int gn(final int triangleIndex) {
    return V[n(triangleIndex)];
  }
  
  private int gp(final int triangleIndex) {
    return V[p(triangleIndex)];
  }
  
  private void initTriangles(int screenSize) {
    G[0] = new PVector(0,0);
    G[1] = new PVector(0,screenSize);
    G[2] = new PVector(screenSize, screenSize);
    G[3] = new PVector(screenSize, 0);
  
    numberOfVertices = 4;
  
    V[0] = 0;
    V[1] = 1;
    V[2] = 2;
    V[3] = 2;
    V[4] = 3;
    V[5] = 0;  
  
    numberOfTriangles = 2;
    numberOfCorners = 6;
  
    buildOTable();
  }

  private void buildOTable() {
    for (int i = 0; i < numberOfCorners; ++i) {
      O[i] = -1;
    }
  
    ArrayList triples = new ArrayList();
    for (int i=0; i<numberOfCorners; ++i) {
      int nextCorner = v(n(i));
      int previousCorner = v(p(i));
      
      triples.add(new Triplet(min(nextCorner,previousCorner), max(nextCorner,previousCorner), i));
    }
  
    myOTableHelper.naiveSort(triples);
  
    // just pair up the stuff
    for (int i = 0; i < numberOfCorners-1; ++i) {
      Triplet t1 = (Triplet)triples.get(i);
      Triplet t2 = (Triplet)triples.get(i+1);
      if (t1.a == t2.a && t1.b == t2.b) {
        O[t1.c] = t2.c;
        O[t2.c] = t1.c;
        i+=1;
      }
    }
  }

  private void computeCircumcenters() {
    hasCircumcircles = false;
    
    for (int i = 0; i < numberOfTriangles; ++i) {
      int c = i*3;
      circumcenters[i] = geometricOperations.circumCenter(G[v(c)],G[v(c+1)],G[v(c+2)]);
      circumcircleRadius[i] = PVector.dist(G[v(c)], (circumcenters[i]));
    }
    hasCircumcircles = true;
  }

  private boolean naiveCheck(float radius, PVector circumcenter, int c) {
    return (PVector.dist(G[v(c)], circumcenter) > radius);
  }
  
  
  private boolean isDelaunay(int c) {
    // $$$FIXME : reuse precomputed cc and cr
    PVector center = geometricOperations.circumCenter(G[v(c)], G[v(n(c))], G[v(p(c))]);
    float radius = PVector.dist(G[v(c)], center);
    return naiveCheck(radius, center, o(c));
  }
  
  
  private void flipCorner(int c) {
    if (c == -1) {
      return;
    }
  
    buildOTable();    
  
    // boundary, do nothing..
    if (o(c) == -1) {
      return;
    }
  
    if (!isDelaunay(c)) {
      int opp = o(c);
      
      V[n(c)] = V[opp];    
      V[n(opp)] = V[c];
  
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
  
  
  private public boolean isInTriangle(int triangleIndex, PVector P) {
    final int c = triangleIndex*3;
  
    PVector A = G[v(c)];
    PVector B = G[v(n(c))];
    PVector C = G[v(p(c))];
  
    if (geometricOperations.isLeftTurn(A,B,P) == geometricOperations.isLeftTurn(B,C,P) &&
        geometricOperations.isLeftTurn(A,B,P) == geometricOperations.isLeftTurn(C,A,P)) {
      return true;
    }
  
    return false;
  }
  
  public void addPoint(final float x, final float y) {
    G[numberOfVertices] = new PVector(x, y);
    ++numberOfVertices;
  
    final int currentNumberOfTriangles = numberOfTriangles;
    for (int triangleIndex = 0; triangleIndex < currentNumberOfTriangles; ++triangleIndex) {
      if (isInTriangle(triangleIndex, G[numberOfVertices-1])) {
        final int A = triangleIndex*3;
        final int B = A+1;
        final int C = A+2;
  
        V[numberOfTriangles*3]   = v(B);
        V[numberOfTriangles*3+1] = v(C);
        V[numberOfTriangles*3+2] = numberOfVertices-1;
  
        V[numberOfTriangles*3+3] = v(C);
        V[numberOfTriangles*3+4] = v(A);
        V[numberOfTriangles*3+5] = numberOfVertices-1;
  
        V[C] = numberOfVertices-1;
        
        ArrayList dirtyCorners = new ArrayList();
        final int d1 = C;
        final int d2 = numberOfTriangles*3+2;
        final int d3 = numberOfTriangles*3+5;
        dirtyCorners.add(d1);
        dirtyCorners.add(d2);
        dirtyCorners.add(d3);
  
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
      PVector A = G[v(c)];
      PVector B = G[v(n(c))];
      PVector C = G[v(p(c))];
      triangle(A.x, A.y, B.x, B.y, C.x, C.y);
    }
  
    strokeWeight(5.0);
    for (int i = 0; i < numberOfVertices; ++i) {
      point(G[i].x, G[i].y);
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
        ellipse(circumcenters[i].x, circumcenters[i].y, 5,5);
        stroke(255,0,0);
        noFill();  
        ellipse(circumcenters[i].x, circumcenters[i].y, circumcircleRadius[i]*2, circumcircleRadius[i]*2);
      }
        
      stroke(0,0,0);
      noFill();
    }
  }
}


private static final int SCREEN_SIZE = 800;
private DelaunayTriangulation delaunayTriangulation = new DelaunayTriangulation(SCREEN_SIZE);
boolean shouldDrawCircumcircles = true;

void setup() {
  size(SCREEN_SIZE, SCREEN_SIZE);
  smooth(); 
}


void draw() {
  background(0);

  pushMatrix();
    delaunayTriangulation.drawTriangles();
    if (shouldDrawCircumcircles) {
      delaunayTriangulation.drawCircumcircles();
    }
  popMatrix();
}


void mouseClicked() {
  if (mouseButton == LEFT) {
    delaunayTriangulation.addPoint(mouseX, mouseY);
    
    if (shouldDrawCircumcircles) {
      delaunayTriangulation.computeCircumcenters();
    }
  }

  if (mouseButton == RIGHT) {
    if (!shouldDrawCircumcircles) {
      delaunayTriangulation.computeCircumcenters();
    }
    shouldDrawCircumcircles = !shouldDrawCircumcircles;
  }
}


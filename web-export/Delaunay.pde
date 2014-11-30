private static final int SCREEN_SIZE = 800;
private DelaunayTriangulation delaunayTriangulation = new DelaunayTriangulation(SCREEN_SIZE);
private boolean shouldDrawCircumcircles = true;

void setup() {
  // This is a processing.js bug that cannot use variable in calling size method.
  size(800, 800);
  smooth(); 
}

void draw() {
  background(0);

  delaunayTriangulation.drawTriangles();
  if (shouldDrawCircumcircles) {
    delaunayTriangulation.drawCircumcircles();
  }
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

// This probably doesn't make sense to be regular class,
// as static final class make more sense here.
// However Jasmine cannot deal with it, so it's for testibility purpose only.
public class GeometricOperations {
  // result is the Z component of 3D cross
  private float cross2D(final Vector2D U, final Vector2D V) {
    return U.v.x*V.v.y - U.v.y*V.v.x;
  }
  
  public boolean isLeftTurn(final PVector A, final PVector B, final PVector C) {
    if (cross2D(new Vector2D(A, B), new Vector2D(B, C)) > 0) {
      return true;
    }
  
    return false;
  }
  
  private PVector intersection(PVector S, PVector SE, PVector Q, PVector QE) {
    Vector2D tangent = new Vector2D(S, SE);
    Vector2D normal = new Vector2D(Q, QE);
    normal.normalize();
    normal.left();
    Vector2D QS = new Vector2D(Q, S);
    
    float QSDotNormal = QS.dot(normal);
    float tangentDotNormal = tangent.dot(normal);
    float t = -QSDotNormal/tangentDotNormal;
    tangent.scaleBy(t);
    return new PVector(S.x+tangent.v.x,S.y+tangent.v.y);
  }
  
  private PVector midVector(PVector A, PVector B) {
    return new PVector( (A.x + B.x)/2, (A.y + B.y)/2 );
  }

  public PVector circumcenter(PVector A, PVector B, PVector C) {
    PVector midAB = midVector(A,B);
    Vector2D AB = new Vector2D(A,B);
    AB.left();
    AB.normalize();
    AB.scaleBy(-1);
  
    PVector midBC = midVector(B,C);
    Vector2D BC = new Vector2D(B,C);
    BC.left();
    BC.normalize();
    BC.scaleBy(-1);  
  
    float fact = 100;
  
    PVector AA = new PVector(midAB.x+AB.v.x*fact, midAB.y+AB.v.y*fact);
    PVector BB = new PVector(midAB.x-AB.v.x*fact, midAB.y-AB.v.y*fact);
    PVector CC = new PVector(midBC.x+BC.v.x*fact, midBC.y+BC.v.y*fact);
    PVector DD = new PVector(midBC.x-BC.v.x*fact, midBC.y-BC.v.y*fact);
    return intersection(AA, BB, CC, DD);  
  }  
}

public class Mesh2D {
  protected static final int BOUNDARY = -1;
  protected int numberOfTriangles = 0;
  protected int numberOfVertices = 0;
  protected int numberOfCorners = 0;

  protected ArrayList corners = new ArrayList();
  protected ArrayList vertices = new ArrayList();
  protected ArrayList opposites = new ArrayList();
  protected OTableHelper myOTableHelper = new OTableHelper();
  protected GeometricOperations geometricOperations = new GeometricOperations();

  protected PVector g(int cornerIndex) {
    return (PVector) vertices.get(v(cornerIndex));
  }
  
  protected int v(int cornerIndex) {
    return (Integer) corners.get(cornerIndex);
  }
  
  protected int o(int cornerIndex) {
    return (Integer) opposites.get(cornerIndex);
  }
  
  protected int n(int c) {
    if (c%3 == 2) {
      return c-2;
    }
    return c+1;
  }
  
  protected int p(int c) {
    if (c%3 == 0) {
      return c+2;
    }
    return c-1;
  }

  protected void buildOTable() {
    opposites = new ArrayList();
    for (int i = 0; i < numberOfCorners; ++i) {
      opposites.add(BOUNDARY);
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
        opposites.set(t1.c, t2.c);
        opposites.set(t2.c, t1.c);
        i+=1;
      }
    }
  }
}
public class OTableHelper {
  private void swap(ArrayList list, int a, int b) {
    Triplet tmp = (Triplet) list.get(a);
    list.set(a, list.get(b));
    list.set(b, tmp);
  }

  private int partition(ArrayList list, int left, int right) {
    int pivotIndex = floor((left + right)/2);
    final Triplet pivotValue = (Triplet) list.get(pivotIndex);
    swap(list, pivotIndex, right);

    int storedIndex = left;
    for (int i=left; i<right; ++i) {
      Triplet currentValue = (Triplet) list.get(i);
      if (currentValue.isLessThan(pivotValue)) {
        swap(list, storedIndex, i);
        ++storedIndex;
      }
    }
    swap(list, right, storedIndex);
    return storedIndex;
  }
  
  private ArrayList naiveQuickSort(ArrayList list, int left, int right) {
    if (left < right) {
      final int pivot = partition(list, left, right);
      naiveQuickSort(list, left, pivot-1);
      naiveQuickSort(list, pivot+1, right);
    }
    return list;
  }

  public ArrayList naiveSort(ArrayList list) {
    return naiveQuickSort(list, 0, list.size()-1);
  }
}
public final class Triplet {
  public final int a;
  public final int b;
  public final int c;
  public Triplet(int a, int b, int c) {
    this.a = a;
    this.b = b;
    this.c = c;
  }
 
  public boolean isLessThan(Triplet rhs) {
    if (a < rhs.a) {
      return true;
    }
    else if (a == rhs.a) {
      if (b < rhs.b) {
        return true;
      }
      else if (b == rhs.b) {
        if (c < rhs.c) {
          return true;
        }
      }
      else {
        return false;
      }
    }
    return false;
  }
}
public class Vector2D {
  private PVector v;

  public Vector2D(PVector A, PVector B) {
    v = new PVector(B.x-A.x, B.y-A.y);
  }
  
  public Vector2D(float x, float y) {
    v = new PVector(x,y,0);
  }
  
  public float dot(Vector2D theOtherVector) {
    return v.dot(theOtherVector.v);
  }
  
  public void normalize() {
    v.normalize();    
  }
  
  public void left() {
    float tmp = v.x;
    v.x = -v.y;
    v.y = tmp;
  }
  
  public void scaleBy(float scalar) {
    v.mult(scalar);
  }
  
  public float x() {
    return v.x;
  }
  
  public float y() {
    return v.y;
  }
}



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

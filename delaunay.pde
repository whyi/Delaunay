// corner table again!!
public static final int SCREEN_SIZE = 800;
public static final int MAX_STUFF = 6000;
int numberOfTriangles = 0;
int numberOfVertices = 0;
int numberOfCorners = 0;

// circumcircles
PVector[] circumcenters = new PVector[MAX_STUFF];
float[] circumcircleRadius = new float[MAX_STUFF];
boolean hasCircumcircles = false;
boolean shouldDrawCircumcircles = true;


// V Table
int[] V = new int[MAX_STUFF];
int[] C = new int[MAX_STUFF*3];


// G Table
PVector[] G = new PVector[MAX_STUFF];


// O-Table
int[] O = new int[MAX_STUFF];
OTableHelper myOTableHelper = new OTableHelper();

int t(int idx) {
  return floor(idx/3);
}

int v(int idx) {
  return V[idx];
}

int o(int idx) {
  return O[idx];
}

int n(int c) {
  if (c%3 == 2) {
    return c-2;
  }

  return c+1;
}

int p(int c) {
  if (c%3 == 0) {
    return c+2;
  }

  return c-1;
}

int g(final int triangleIndex) {
  return V[triangleIndex*3];
}

int gn(final int triangleIndex) {
  return V[n(triangleIndex)];
}

int gp(final int triangleIndex) {
  return V[p(triangleIndex)];
}


// result is the Z component of 3D cross
float cross2D(final Vector2D U, final Vector2D V) {
  return U.v.x*V.v.y - U.v.y*V.v.x;
}

boolean isLeftTurn(final PVector A, final PVector B, final PVector C) {
  if (cross2D(new Vector2D(A, B), new Vector2D(B, C)) > 0) {
    return true;
  }

  return false;
}

boolean isInTriangle(int triangleIndex, PVector P) {
  final int c = triangleIndex*3;

  PVector A = G[v(c)];
  PVector B = G[v(n(c))];
  PVector C = G[v(p(c))];

  if (isLeftTurn(A,B,P) == isLeftTurn(B,C,P) && isLeftTurn(A,B,P) == isLeftTurn(C,A,P)) {
    return true;
  }

  return false;
}

void initTriangles() {
  G[0] = new PVector(0,0);
  G[1] = new PVector(0,SCREEN_SIZE);
  G[2] = new PVector(SCREEN_SIZE, SCREEN_SIZE);
  G[3] = new PVector(SCREEN_SIZE, 0);

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

void mouseClicked() {
  if (mouseButton == LEFT) {
    addPoint(mouseX, mouseY);
    
    if(shouldDrawCircumcircles) {
      computeCircumcenters();
    }
    
    return;
  }

  if (mouseButton == RIGHT) {
    if (!shouldDrawCircumcircles) {
      computeCircumcenters();
    }
    shouldDrawCircumcircles = !shouldDrawCircumcircles;
  }
}

void buildOTable() {
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


PVector intersection(PVector S, PVector SE, PVector Q, PVector QE) {
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


void computeCircumcenters() {
  hasCircumcircles = false;
  
  for (int i = 0; i < numberOfTriangles; ++i) {
    int c = i*3;
    circumcenters[i] = circumCenter(G[v(c)],G[v(c+1)],G[v(c+2)]);
    circumcircleRadius[i] = PVector.dist(G[v(c)], (circumcenters[i]));
  }
  hasCircumcircles = true;
}


PVector midPVector(PVector A, PVector B) {
  return new PVector( (A.x + B.x)/2, (A.y + B.y)/2 );
}


PVector circumCenter(PVector A, PVector B, PVector C) {
  PVector midAB = midPVector(A,B);
  Vector2D AB = new Vector2D(A,B);
  AB.left();
  AB.normalize();
  AB.scaleBy(-1);

  PVector midBC = midPVector(B,C);
  Vector2D BC = new Vector2D(B,C);
  BC.left();
  BC.normalize();
  BC.scaleBy(-1);  

  float fact = 100;

  PVector AA = new PVector( midAB.x+AB.v.x*fact, midAB.y+AB.v.y*fact);
  PVector BB = new PVector( midAB.x-AB.v.x*fact, midAB.y-AB.v.y*fact);
  PVector CC = new PVector( midBC.x+BC.v.x*fact, midBC.y+BC.v.y*fact);
  PVector DD = new PVector( midBC.x-BC.v.x*fact, midBC.y-BC.v.y*fact);
  return intersection(AA, BB, CC, DD);  
}


boolean naiveCheck (final float radius, final PVector cc, final int c) {
  int A = v(c);

  if (PVector.dist(G[A], cc) < radius) {
    return false;
  }

  return true;
}


boolean isDelaunay(int c) {
  // $$$FIXME : reuse precomputed cc and cr
  PVector center = circumCenter(G[v(c)], G[v(n(c))], G[v(p(c))]);
  float radius = PVector.dist(G[v(c)], center);
  return naiveCheck(radius, center, o(c));
}


void flipCorner(int c) {
  if (c == -1) {
    return;
  }

  buildOTable();    

  // boundary, do nothing..
  if( o(c) == -1 ) {
    return;
  }

  if(!isDelaunay(c)) {
    int opp = o(c);
    
    V[n(c)] = V[opp];    
    V[n(opp)] = V[c];

    buildOTable();
    flipCorner(c);
    buildOTable();
    flipCorner(n(opp));
  }
}


void fixMesh(ArrayList l) {
  buildOTable();

  while (!l.isEmpty()) {
    final int c = (Integer)l.get(0);
    flipCorner(c);
    l.remove(0);
  }
}


void addPoint(final float x, final float y) {
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


void drawTriangles() {
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


void drawCircumcircles() {
  if (!hasCircumcircles) {
    return;
  }

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


void setup() {
  size(SCREEN_SIZE, SCREEN_SIZE);
  smooth(); 
  initTriangles();
}


void draw() {
  background(0);

  pushMatrix();
    drawTriangles();
    if (shouldDrawCircumcircles) {
      drawCircumcircles();
    }
  popMatrix();
}

class Vector2D {
  PVector v;

  Vector2D(final PVector A, final PVector B) {
    v = new PVector(B.x-A.x, B.y-A.y);
  }
  
  Vector2D(final float x, final float y, final float z) {
    v = new PVector(x,y,z);
  }
  
  float dot(final Vector2D point) {
    return v.x*point.v.x + v.y*point.v.y;
  }
  
  void normalize() {
    final float factor = sqrt(v.x*v.x+v.y*v.y+v.z*v.z);
    v.x /= factor;
    v.y /= factor;
    v.z /= factor;    
  }
  
  void left() {
    float tmp = v.x;
    v.x = -v.y;
    v.y = tmp;
  }
  
  void scaleBy (final float factor) {
    v.x*=factor;
    v.y*=factor;
  }
}

// corner table again!!
final int SCREEN_SIZE = 800;
final int MAX_STUFF = 6000;
int nt = 0;
int nv = 0;
int nc = 0;

// circumcenters;
PVector[] cc = new PVector[MAX_STUFF];
boolean hasCC = false;
boolean bRenderCC = true;
float[] cr = new float[MAX_STUFF];

// V Table
int[] V = new int[MAX_STUFF];
int[] C = new int[MAX_STUFF*3];
boolean[] visited = new boolean[MAX_STUFF*3];

// G Table
PVector[] G = new PVector[MAX_STUFF];

// O-Table
int[] O = new int[MAX_STUFF];
OTableHelper oTableHelper = new OTableHelper();

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

float dot(final Vector2D v1, final Vector2D v2) {
  return v1.dot(v2);
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

boolean isInTriangle(final int triangleIndex, final PVector P) {
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

  nv = 4;

  V[0] = 0;
  V[1] = 1;
  V[2] = 2;
  V[3] = 2;
  V[4] = 3;
  V[5] = 0;  

  nt = 2;
  nc = 6;

  buildOTable();
}

void mouseClicked() {
  if (mouseButton == LEFT) {
    addPoint(mouseX, mouseY);
    
    if(bRenderCC) {
      computeCC();
    }
    
    return;
  }

  if (mouseButton == RIGHT) {
    if (!bRenderCC) {
      computeCC();
    }
    bRenderCC = !bRenderCC;
  }
}

void buildOTable() {
  for (int i = 0; i < nc; ++i) {
    O[i] = -1;
  }

  ArrayList vtriples = new ArrayList();
  for(int ii=0; ii<nc; ++ii) {
    int n1 = v(n(ii));
    int p1 = v(p(ii));
    
    vtriples.add(new Triplet(min(n1,p1), max(n1,p1), ii));
  }

  ArrayList sorted = new ArrayList();
  sorted = oTableHelper.naiveSort(vtriples);

  // just pair up the stuff
  for (int i = 0; i < nc-1; ++i) {
    Triplet t1 = (Triplet)sorted.get(i);
    Triplet t2 = (Triplet)sorted.get(i+1);
    if (t1.a == t2.a && t1.b == t2.b) {
      O[t1.c] = t2.c;
      O[t2.c] = t1.c;
      i+=1;
    }
  }
}


PVector intersection(PVector S, PVector SE, PVector Q, PVector QE) {
  Vector2D T = new Vector2D(S, SE);
  Vector2D N = new Vector2D(Q, QE);
  N.normalize();
  N.left();
  Vector2D QS = new Vector2D(Q, S);
  
  float QS_dot_N = dot(QS,N);
  float T_dot_N = dot(T,N);
  float t = -QS_dot_N/T_dot_N;
  T.scaleBy(t);
  return new PVector(S.x+T.v.x,S.y+T.v.y);
}


void computeCC() {
  hasCC = false;
  
  for (int i = 0; i < nt; ++i) {
    int c = i*3;
    cc[i] = circumCenter(G[v(c)],G[v(c+1)],G[v(c+2)]);
    cr[i] = PVector.dist(G[v(c)], (cc[i]));
  }
  hasCC = true;
}

void renderCC() {
  if (!hasCC) {
    return;
  }

  stroke(255,0,0);
  noFill();
  strokeWeight(1.0);

  for (int i = 3; i < nt; ++i) {
    stroke(0,0,255);
    fill(0,0,255);
    ellipse(cc[i].x, cc[i].y, 5,5);
    stroke(255,0,0);
    noFill();  
    ellipse(cc[i].x, cc[i].y, cr[i]*2, cr[i]*2);
  }
    
  stroke(0,0,0);
  noFill();
}

PVector midPVector (final PVector A, final PVector B) {
  return new PVector( (A.x + B.x)/2, (A.y + B.y)/2 );
}

PVector circumCenter (final PVector A, final PVector B, final PVector C) {
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

boolean isDelaunay (int c) {
 // $$$FIXME : reuse precomputed cc and cr
  PVector center = circumCenter(G[v(c)], G[v(n(c))], G[v(p(c))]);
  float radius = PVector.dist(G[v(c)], center);
  return( naiveCheck(radius, center, o(c)) );
}

void flipCorner (int c) {
  if( c == -1 ) {
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
  G[nv] = new PVector(x, y);
  ++nv;

  final int currentNumberOfTriangles = nt;
  for (int triangleIndex = 0; triangleIndex < currentNumberOfTriangles; ++triangleIndex) {
    if (isInTriangle(triangleIndex, G[nv-1])) {
      final int A = triangleIndex*3;
      final int B = A+1;
      final int C = A+2;

      V[nt*3]   = v(B);
      V[nt*3+1] = v(C);
      V[nt*3+2] = nv-1;

      V[nt*3+3] = v(C);
      V[nt*3+4] = v(A);
      V[nt*3+5] = nv-1;

      V[C] = nv-1;
      
      ArrayList dirtyCorners = new ArrayList();
      final int d1 = C;
      final int d2 = nt*3+2;
      final int d3 = nt*3+5;
      dirtyCorners.add(d1);
      dirtyCorners.add(d2);
      dirtyCorners.add(d3);

      nt += 2;
      nc += 6;
      fixMesh(dirtyCorners);
      break;
    }
  }
}

void drawTriangles() {
  noFill();
  strokeWeight(1.0);
  stroke(0,255,0);

  for (int i = 0; i < nt; ++i) {
    final int c = i*3;
    final PVector A = G[v(c)];
    final PVector B = G[v(n(c))];
    final PVector C = G[v(p(c))];
    triangle(A.x, A.y, B.x, B.y, C.x, C.y);
  }

  strokeWeight(5.0);
  for (int i = 0; i < nv; ++i) {
    point(G[i].x, G[i].y);
  }
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
    if (bRenderCC) {
      renderCC();
    }
  popMatrix();
}

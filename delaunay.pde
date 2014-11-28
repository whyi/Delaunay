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


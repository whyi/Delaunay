public class Vector2D {
  private PVector v;

  Vector2D(PVector A, PVector B) {
    v = new PVector(B.x-A.x, B.y-A.y);
  }
  
  Vector2D(float x, float y, float z) {
    v = new PVector(x,y,z);
  }
  
  float dot(Vector2D theOtherVector) {
    return v.dot(theOtherVector.v);
  }
  
  void normalize() {
    v.normalize();    
  }
  
  void left() {
    float tmp = v.x;
    v.x = -v.y;
    v.y = tmp;
  }
  
  void scaleBy(float scalar) {
    v.mult(scalar);
  }
}


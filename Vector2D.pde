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


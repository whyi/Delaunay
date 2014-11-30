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
    return new PVector(S.x+tangent.v.x,S.y+tangent.v.y,0);
  }
  
  private PVector midVector(PVector A, PVector B) {
    return new PVector((A.x + B.x)/2, (A.y + B.y)/2, 0);
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
  
    final float fact = 100;
  
    PVector AA = new PVector(midAB.x+AB.v.x*fact, midAB.y+AB.v.y*fact, 0);
    PVector BB = new PVector(midAB.x-AB.v.x*fact, midAB.y-AB.v.y*fact, 0);
    PVector CC = new PVector(midBC.x+BC.v.x*fact, midBC.y+BC.v.y*fact, 0);
    PVector DD = new PVector(midBC.x-BC.v.x*fact, midBC.y-BC.v.y*fact, 0);
    return intersection(AA, BB, CC, DD);  
  }  
}


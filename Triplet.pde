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

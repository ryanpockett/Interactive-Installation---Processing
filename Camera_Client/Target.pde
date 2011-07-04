
// target Class
// so that we can dynamically create new targets (instances of Target)

class Target {
  public Target(float _x, float _y, float _w, float _h) { //basic constructor
    x = _x; 
    y = _y; 
    w = _w; 
    h = _h; 
    active = false;
    closestBlob = null;
    closestBlobDistance = 0;
  } 
  
  boolean inside(float px, float py) {    //method; checks if given point is inside target
    float dx = px - x;
    float dy = py - y;
    return (dx*dx)/(w*w/4) + (dy*dy)/(h*h/4) <= 1;
  }

  boolean active; // is this target active?
  Blob closestBlob; // holds closest overlapping blob to this target
  float closestBlobDistance; // holds distance to closest overlapping blob to this target
  
  float x, y, w, h;  
}

part of rapid;

const double GRAVITY = 9.8665; //Earth gravity m/s^2

// Define a container world class
class World
{
  double               _timer = 0.0;
  KdTree<Body>         _space;

  World.empty()
  {
    _space = new KdTree.fromList([], []);
  }

  World.fromList(List<Body> objs) {
    var points = [];
    objs.forEach((o) => points.add(o.center));
    _space = new KdTree.fromList(points, objs);
  }

  void addObject(Body obj) {
    _space.insert(obj.pos, obj);
  }

  void removeObject(Body obj) {
    _space.remove(obj.pos);
  }

  //Get the current elapsed time in milliseconds for the simulation
  get timestamp => _timer;
  //Set the current elapsed [time] in milliseconds for this simulation
  set timestamp(double time) {
    var delta = time - _timer;
    update(delta);
  }

  //Update the simulation by [delta] milliseconds
  void update(double delta)
  {
    // ***** O(n) *****
    //For each obj in space
    //Remove obj from space
    //Update obj pos
    //Add obj in space

    // ***** O(log2(n)n^2) *****
    //For each obj1 in space
     //remove from space
     //For each obj2 in space
        // ***** O(log2(n)) worst = O(n) *****
        //while Test collisions
        //remove from space obj2
        //correct pos obj2
        //correct pos obj1
        //add in space obj2
     //add obj1 in space

    //Increment timer
    _timer += delta;
  }
}
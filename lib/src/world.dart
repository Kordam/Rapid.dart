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
    //For each obj in space
    //Remove from space
    //Update pos
    //Add in space
    //while Test collisions
      //remove from space
      //correct pos
      //add in space

    //Increment timer
    _timer += delta;
  }
}
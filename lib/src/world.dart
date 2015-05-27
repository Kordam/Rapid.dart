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
    //Insert in space
    _space.insert(obj.pos, obj);
    //Compute incoming collisions with objects
     //Find nearest OBJs
     //Test nearest OBJs
     //Register collisions in nearest OBJS
     //Registers collisions with nearest OBJs
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
  //Should take approximately O(n * log2(n))
  void update(double delta)
  {
    //For each obj in space
    //Remove obj from space
    //While obj timestamp + delta not meet
      //Update obj pos until next collisions
        //Compute collision reaction
        //Update collision obj to time
        //Find nearest OBjS
        //Test nearest OBJs
        // Register collisions in nearest OBJ
        // Register collisions in current OBJ
    //Add obj in space

    //Increment timer
    _timer += delta;
  }
}
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
    //Compute incoming collisions with objects // O(??)
     //Find nearest OBJs //O(n log(n))
     //Test nearest OBJs // O(n log(n))
     //Register collisions in nearest OBJS O(1)
     //Registers collisions with nearest OBJs O(1)
  }

  void removeObject(Body obj) {

    //Clear scheduled collisions

    //Removed from working space
    _space.remove(obj.pos);
  }

  //Get the current elapsed time in milliseconds for the simulation
  get timestamp => _timer;
  //Set the current elapsed [time] in milliseconds for this simulation
  set timestamp(double time) {
    var delta = time - _timer;
    update(delta);
  }

  //Runs the simulation at 60 fps
  void run60() {
    const double fps = 60.0;
    const double dt = 1 / fps;
    double accumulator = 0.0;
    // In units seconds
    DateTime frameStart = new DateTime.now();

    // main loop
    while (true) {
      DateTime currentTime = new DateTime.now();
      //const double currentTime = GetCurrentTime();

      // Store the time elapsed since the last frame began
      accumulator += currentTime.compareTo(frameStart);

      //Debug dart time instead of doubles
      print(accumulator);

      // Record the starting of this frame
      frameStart = currentTime;

      // Avoid spiral of death and clamp dt, thus clamping
      // how many times the UpdatePhysics can be called in
      // a single game loop.

      if (accumulator > 0.2) {
        accumulator = 0.2;
      }


      while (accumulator > dt) {
        update(dt);
        accumulator -= dt;
      }
    }
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
        //Clear old collisions
        //Find nearest OBJS
        //Test nearest OBJs
        // Register collisions
        // in nearest OBJ
        // Register collisions in current OBJ
    //Add obj in space

    //Increment timer
    _timer += delta;
  }
}
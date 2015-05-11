part of rapid;

const double GRAVITY = 9.8665; //Earth gravity m/s^2

// Define a container world class
class World
{
  double                      timer = 0.0;
  StreamController<Collision> collisions = new StreamController<Collision>();
  KdTree<Collider>            space;

  World.empty()
  {
    space = new KdTree.fromList([], []);
  }

  World.fromList(List<Collider> objs) {
    var points = [];
    objs.forEach((o) => points.add(o.center));
    space = new KdTree.fromList(points, objs);
  }

  //Update the simulation by [delta] seconds
  void update(double delta)
  {

  }

  //Every collision that occurs is pushed to a stream
  //of [Collision] events
  get collisionStream => collisions.stream;
}
part of rapid;

//Define a rigid body container class
class Body
{
  var      _local_timer = 0.0;
  Collider _bounds;

  Body();

  //Moves a body of [delta] in model space
  void translate(Vector3 delta) {
    _bounds.translate(delta);
  }

  //Rotate a body by the givens euler [angles] in degree
  void rotate(Vector3 angles) {
    _bounds.rotate(angles);
  }

  get pos => _bounds.center;
  get timestamp => _local_timer;
  set timestamp(double time) => _local_timer = time;
}
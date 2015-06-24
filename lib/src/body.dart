part of rapid;

//Define a rigid body container class
class Body
{
  var           _local_timer = 0.0;
  List<Vector3> _vertices;
  List<int>     _faces;
  Collider      _bounds;

  Body.empty() {
    _vertices = new List<Vector3>();
    _faces = new List<int>();
    _bounds = null;
  }

  //Creates a body from a list of [faces] and
  //linked [vertices]
  //TODO add Collider choice
  Body.fromTriangles(List<Vector3> vertices, List<int> faces) {
    _vertices == vertices;
    _faces = faces;
    _bounds = new ObbCollider.fromTriangles(_faces, _vertices);
  }

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
part of rapid;

//Define a rigid body container class
class Body
{
  Collider _bounds;

  Body();

  //Moves a body of [delta] in model space
  void translate(Vector3 delata) {

  }

  //Rotate a body by the givens euler [angles] in degree
  void rotate(Vector3 angles) {

  }

  get pos => _bounds.center;
}
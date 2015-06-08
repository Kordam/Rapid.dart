part of rapid;

//Defines colliders type
enum ColliderType  { OBB, ABB, SPHERE }

//Defines an abstract collider class
abstract class Collider
{
  Matrix4      _model;
  ColliderType _type;

  Collider(this._type) {
    _model = new Matrix4.zero().setIdentity();
  }

  get type => _type;
  set type(var type) => _type = type;

  //Mandatory getter properties
  get center;

  //Model space control interface
  //Translate this collider by [vec]
  void   translate(Vector3 vec)  {
    _model.translate(vec);
  }
  //Rotate from euler angles
  void   rotate(double x, double y, double z) {
    _model.rotateX(x);
    _model.rotateY(y);
    _model.rotateZ(z);
  }

  //Collision interface to define in inherited class
  bool collideWithObb(ObbCollider oth, {List<int> idx: null, List<Vector3> points: null});
  bool collideWithAbb(ObbCollider oth, {List<int> idx: null, List<Vector3> points: null});
  bool collideWithSphere(ObbCollider oth, {List<int> idx: null, List<Vector3> points: null});

  //Check if two colliders are in contact
  //by calling the appropriate collision test method
  bool collideWith(Collider oth) {
    switch (oth._type) {
      case ColliderType.OBB:
        return collideWithObb(oth);
      case ColliderType.ABB:
        return collideWithAbb(oth);
      case ColliderType.SPHERE:
        return collideWithSphere(oth);
    }
    return false;
  }

}
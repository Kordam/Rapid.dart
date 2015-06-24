part of rapid;

//Defines colliders type
enum ColliderType  { OBB, ABB, SPHERE }

//Defines an abstract collider class
abstract class Collider
{
  ColliderType _type;

  Collider(this._type) {
  }

  get type => _type;
  set type(var type) => _type = type;

  //Mandatory getter properties
  get center;

  //Model space control interface
  //Translate this collider by [vec]
  void   translate(Vector3 vec);


  //Rotate a body by the givens euler [angles] in degree
  void   rotate(Vector3 angles);

  //Collision interface to define in inherited class
  bool collideWithObb(ObbCollider oth, {List<int> idx: null, List<Vector3> points: null});
  bool collideWithAbb(ObbCollider oth, {List<int> idx: null, List<Vector3> points: null});
  bool collideWithSphere(ObbCollider oth, {List<int> idx: null, List<Vector3> points: null});

  //Check if two colliders are in contact
  //by calling the appropriate collision test method
  //If so, Lists of colliding [points] and faces [idx] can be filled
  bool collideWith(Collider oth, {List<int> idx: null, List<Vector3> points: null}) {
    switch (oth._type) {
      case ColliderType.OBB:
        return collideWithObb(oth, idx: idx, points: points);
      case ColliderType.ABB:
        return collideWithAbb(oth, idx: idx, points: points);
      case ColliderType.SPHERE:
        return collideWithSphere(oth, idx: idx, points: points);
    }
    return false;
  }

}
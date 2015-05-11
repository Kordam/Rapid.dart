part of rapid;

//Defines a collision event
//It append between two [Collider] objects
//At the [timestamp] mark
class Collision
{
  final Collider a;
  final Collider b;
  final double   timestamp;

  Collision(this.a, this.b, this.timestamp);
}
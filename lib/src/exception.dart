//This file contains the custom exception classes for rapid.dart

part of rapid;

//Define exception that occurs when an oriented bounding box
//is considered to be inseparable. (Not split axis found)
class SplitBoxException implements Exception
{
  String what;
  SplitBoxException(this.what);
}
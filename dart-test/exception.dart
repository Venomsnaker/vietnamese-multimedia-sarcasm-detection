class MinAgeException implements Exception {
  final String _message;

  const MinAgeException(this._message);

  @override
  String toString() => _message;
}

void check(int age){
  if(age < 18){
    throw new MinAgeException("You aren't a knight");
  }
  else
  {
    print("You are a Knight");
  }
}

void main() {
  int s1 = 20;
  int s2 = 10;
  
  try{
    check(s1);
    check(s2);
  }
  on MinAgeException catch(e){
    print(e.toString());
  }
}


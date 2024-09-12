class Test {
  static var s2;
  String s1 = ' ';

  void printS1() {
    print("Welcome to $s1");
  }

  String get getS1 {
    return s1;
  }

  void set setS1(String s1) {
    this.s1 = s1;
  }

  Test() {
    s2 = "Mohg";
    print("Parent Constructor");
  }
}

class Test1 extends Test {
  Test1() : super () {
    print("Child Constructor");
  }

  void info() {
    super.printS1();
  }

  @override
  String get getS1 => super.getS1;
}

void main() {
  Test test = new Test();
  test.s1 = "Putrescent Knight";
  test.printS1();

  Test1 t = new Test1();
  print(Test.s2);
  t.info();
}
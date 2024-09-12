int add(int a, int b) {
  int result = a + b;
  return result;
}

void test1(int g1, [var g2]) {
  print("g1 is $g1");
  print("g2 is $g2");
}

void test2(int g1, {g2, g3}) {
  print("g1 is $g1");
  print("g2 is $g2");
  print("g3 is $g3");
}

void test3(int g1, {int g2 = 12}) {
  print("g1 is $g1");
  print("g2 is $g2");
}

int fibonacci(int n) {
  return n < 2 ? n : (fibonacci( - 1) + fibonacci( - 2));
}

void main() {
  int output = add(10, 12);
  print(output);
  test1(01);
  test2(01, g3 : 12);
  test3(01);

  var list = ["Those", "united", "in", "common"];
  list.forEach((item) {
    print("${list.indexOf(item)}: $item");
  });
}
import "dart:io";

void main() {
  print("Enter you name");
  String? name = stdin.readLineSync();
  print("Hello, $name! \n Welcome to Dart.");
}
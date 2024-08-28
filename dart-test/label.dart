void main() {
  TestLabel: for (int i = 0; i < 3; i++) {
    if (i < 2) {
      print("Inside the loop");
      break TestLabel;
    }
    print("Still inside the loop;");
  }

  TestLabel2: for (int i = 0; i < 3; i++) {
    if (i < 2) {
      print("Inside the loop");
      continue TestLabel2;
    }
    print("Still inside the loop;");
  }
}
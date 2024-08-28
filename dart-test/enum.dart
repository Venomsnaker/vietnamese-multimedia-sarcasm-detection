enum EnumTest {
  Putrescent,
  Knight
}

void main() {
  for (EnumTest e in EnumTest.values) {
    print(e);
  }
}
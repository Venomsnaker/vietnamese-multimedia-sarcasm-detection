Iterable testIterable(int number) sync* {
  int count = number;
  
  while(count >= 0) {
    if (count % 2 == 0) {
      yield count;
    }
    count--;
  }
}

void main() {
  testIterable(10).forEach(print);
}
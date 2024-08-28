void main() {
  int x = 5;
  int y = 7;

  if((++x > y--) && (++x < ++y)) {
    print("Condition true");
  } else {
    print("Condition false");
  }
  print(x);
  print(y);

  int testvar = 1;
  switch(testvar) {
    case 1:
    {
      print("Case 1");
      break;
    } 
    case 2:
    {
      print("Case 2");
      break;
    }
  }
}
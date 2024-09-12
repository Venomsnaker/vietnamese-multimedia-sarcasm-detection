/*
  is and is!
  ??= assign only if it is null
  && and || and !
  short hand condition: conditon ? expression1 : expression2
  short hand nonNull expression1 ?? expression2
*/

void special() {
  final var1 = "Can't be change";

  dynamic dvar = "a";
  dvar = "b";

  int? nullvar;
  nullvar = null;
  print("$var1 - $dvar");
  print(nullvar);
}

void main() {
  int var1 = 10;
  double var2 = 0.69;
  bool var3 = false;
  String var4 = "hello there", var5 = "0";

  print("$var1 - $var2 - $var3 - $var4 - $var5");
  special();
}
import 'dart:collection';

void main() {
  List<String> gfg = List<String>.filled(3, "default");
  gfg[0] = 'Putrescent';
  gfg[1] = 'Knight';

  print(gfg);

  Map m = new Map();
  m['First'] = 'Putrescent';
  m['Second'] = 'Knight';
  print(m);

  // need dart:collection
  Queue<String> q = new Queue<String>();
  print(q);
  q.add("Putrescent");
  q.add("Knight");
  print(q);
}
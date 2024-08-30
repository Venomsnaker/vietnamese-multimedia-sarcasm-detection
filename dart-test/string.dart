void main() {
  String s = "Putrescent Knight of St. Trina";
  s = s.replaceAll("Knight", "Shield");
  List<String> s_list = s.split(" ");

  String s2 = "There1is2something3in4the5night";
  print(s2.split(new RegExp(r"[0-9]")));
  print(s_list);
  print(s_list.join("_"));

  print(s2.codeUnits);
}
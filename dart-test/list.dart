main() {
  List<String> l1 = ['Putrescent'];
  List<String> l2 = ['Knight'];
  List<String> l3 = ['St', ".", "Trina"];
  List<String> newL = [l1, l2, l3].expand((x) => x).toList();
  print(newL);
  newL.sort((a, b) => a.length.compareTo(b.length));
  print(newL);
}
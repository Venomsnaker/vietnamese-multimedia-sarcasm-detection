void main() {
  var teas = ['green', 'black', 'chamomile', 'earl grey'];

  bool isDecaffeinated(String teaName) => teaName == 'chamomile';

  print(teas.any(isDecaffeinated));
}


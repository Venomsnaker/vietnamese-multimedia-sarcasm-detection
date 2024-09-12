void main(){ 
  var uri = 'https://example.org/api?foo=some message'; 
  
  var encoded = Uri.encodeComponent(uri); 
  assert(encoded == 
      'https%3A%2F%2Fexample.org%2Fapi%3Ffoo%3Dsome%20message'); 
    
  var decoded = Uri.decodeComponent(encoded); 
  print(uri == decoded); 
} 

import 'dart:convert';
void main() {
  String jsonText = '''
[1, 5, 8, 3, 2]
''';
  String jsonText2 = '''
{
"group": "Dart",
"students": ["Ola", "Adam", "Kasia"]
}
''';
  String jsonText3 = '''
{
"product": {
"name": "Laptop",
"price": 3500
}
}
''';
// podpowiedź
  //final lista = data["nazwa_listy"];
  //int dlugosc_listy = lista.length;

  final lista = jsonDecode(jsonText);
  int suma = 0;
  int i = 0;
  var len = lista.length;
  for (i = 0; i < len; i++) {
    print(lista[i]);
  }

  print("----------------------");
final lista2=jsonDecode(jsonText2);
  print(lista2["group"]);
  print(lista2["students"]);
  final lista3=jsonDecode(jsonText3);
  print("----------------------");
  print(lista3["product"]["name"]);
  print(lista3["product"]["price"]);




}


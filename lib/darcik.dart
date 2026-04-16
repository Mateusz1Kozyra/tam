// import 'package:flutter/material.dart';
//
// void main() {
//   runApp(MyApp());
// }
//
// // class MyApp extends StatelessWidget {  //StatelessWidget widget bez stanu
// //   @override
// //   Widget build(BuildContext context) {   // build() funkcja ktora rysuje interfejs i zwraca Widget
// //     return MaterialApp(  //MaterialApp cała aplikacja
// //       home: Scaffold( //Scaffold szkielet ekranu
// //         appBar: AppBar( //w tym szkielecie ekranu jest AppBar - górny pasek
// //           title: Text("KrakFlow"),
// //         ),
// //         body: Text("Hello"), // body - zwartość, główna część ekranu
// //       ),
// //     );
// //   }
// // }
//
//
// class MyApp extends StatelessWidget {  //StatelessWidget widget bez stanu
//   List<Task> tasks=[
//     Task(title:"Projekt Flutter",deadline:"16.04"),
//     Task(title:"Kolokwium Flutter", deadline:"16.04"),
//     Task(title: "PSI czyli psi przedmiot", deadline: "dzisiaj")
//   ];
//   List<String> items =["element1","element2","element3"];
//
//   @override
//   Widget build(BuildContext context) {   // build() funkcja ktora rysuje interfejs i zwraca Widget
//     return MaterialApp(  //MaterialApp cała aplikacja
//         home: Scaffold( //Scaffold szkielet ekranu
//             appBar: AppBar( //w tym szkielecie ekranu jest AppBar - górny pasek
//                 title: Center(child: Text("KrakFlow"),)
//             ),
//             // body: Center(child:
//             // Column(
//             //   children: [
//             //     Text("Element 1"),
//             //     Text("Element 2")
//             //   ],)
//             // ROBIONE PRZZEZ WPISYWANIE
//             // body: ListView(children: [    //nie wycentruje Center() bo ListView domyślnie zajmuje całą szerokośc i wysokość
//             //   Text("Element 1"),
//             //   Text("Element 2"),
//             // ],
//
//             //ROBIONE DYNAMICZNIE:
//             body: ListView.builder(
//                 itemCount: items.length,  // itemCount określa liczbę elementów listy
//                 itemBuilder: (context,index){ //itemBuilder buduje pojedynczy element
//                   return Text(items[index]); // index oznacza numer aktualnego elementu dla index 0 pierwszy element itd..
//                   //       },
//                   //     ),
//                   body: TaskCard(   //flutter wchodzi do Scaffolda, ma dane i na podstawie ich przechodzi do
//                     //class TaskCard extends StatelessWidget i tam buduje widget za pomocą funkcji build(), która zwraca Card()
//                     title: "Projekt Flutter",
//                     subtitle: "termin: jutro",
//                     icon: Icons.task,
//                   ),
//                   ),
//                   );
//                 }
//                 }
//
//   class Task {
//   final String title;
//   final String deadline;
//   Task({required this.title, required this.deadline});
//   }
//
//
// //TaskCard własny widget, który wyświetla jedno zadanie
//   class TaskCard extends StatelessWidget {
//   final String title;
//   final String subtitle;        //tutaj zmienne akurat stałe
//   final IconData icon;
//   const TaskCard({              //konstruktor
//   super.key,
//   required this.title,
//   required this.subtitle,
//   required this.icon,
//   });
//   @override
//   Widget build(BuildContext context) { //tu se nadpisuje budowanie widżeta
//   // czyli se go buduje za pomocą funkcji Card, która robi wizualną kartę
//   //i to jest ten jeden klocek o którym mowa była w pdfie
//   return Card(
//   child: ListTile(
//   leading: Icon(icon),
//   title: Text(title),
//   subtitle: Text(subtitle),
//   ),
//   );
//   }
//   }

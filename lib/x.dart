//lab 4

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  final List<Task> tasks = [
    Task(title: "Projekt Flutter", deadline: "jutro", done:false,priority: "Średni"),
    Task(title: "Kolokwium", deadline: "dzisiaj", done:true,priority:"Niski"),
    Task(title: "Nauka", deadline: "piątek",done:false,priority: "Wysoki"),
  ];


  @override
  Widget build(BuildContext context) {
    var wykonane=0;
    for(var i=0; i<tasks.length; i++){
      if (tasks[i].done== true){
        wykonane=wykonane+1;}}
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("KrakFlow"),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [


            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Masz dziś ${tasks.length} zadania",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Dzisiejsze zadania",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text("Zostało wykonane: ${wykonane}",
                    style:TextStyle(
                        fontSize:22,fontWeight:FontWeight.bold,color:Colors.blue
                    )),
              ],
            ),

            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {


                  return TaskCard(

                    title: tasks[index].title,
                    subtitle: "termin: ${tasks[index].deadline} + priorytet ${tasks[index].priority}",
                    icon: tasks[index].done? Icons.check_circle : Icons.radio_button_unchecked,
                  );

                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Task {
  final String title;
  final String deadline;
  final bool done;
  final String priority;


  Task({required this.title, required this.deadline,required this.done,required this.priority});


}

class TaskCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;


  const TaskCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,

  });


  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon),
            Text(title),
            Text(subtitle),
          ],

        ),
      ),
    );
  }
}

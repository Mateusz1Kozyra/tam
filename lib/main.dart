import 'package:flutter/material.dart';

void main() {
  //runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  List<Task> tasks = [
    Task(title: "projekt z flutter", deadline: "20.20"),
    Task(title: "porozmawiac z mamą", deadline: "26.03.2026:22:30"),
    Task(title: "Obejrzec baraze Polska - Albania", deadline: "26.03.2026"),
    Task(title: "zrobic modul 9/10 z sieci dzisiaj", deadline: "26.03.2026")
  ];

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //to ona mówi co ten widget ma narysować na ekranie
    return MaterialApp(
        title: 'Flutter Demo',
        home: Column(
          children: [
            Text("Dzisiejsze zadania nad listą",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
              ),
            ),
            Expanded(child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  return TaskCard(
                      title: tasks[index].title,
                      subtitle: tasks[index].deadline,
                      icon: tasks[index].icon);
                }))

          ],

        ));
        }
}

class Task {
  final String title;
  final String deadline;
  IconData icon = Icons.import_contacts_rounded;

  Task({required this.title, required this.deadline});
}

class TaskCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const TaskCard(
      {super.key, required this.title, required this.subtitle, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(subtitle),
      ),
    );
  }
}


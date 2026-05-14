import 'package:flutter/material.dart';
import 'services/task_repository.dart';
import 'services/task_api_service.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'services/task_repository.dart';

import 'package:hive_ce_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter(); // inicjalizacja
  await Hive.openBox("tasks"); // otwarcie kontenera
runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedFilter = "wszystkie";
  String filter = "wszystkie";
  late Future<List<Task>> tasksFuture;
  int alltasksCount=0;
  int doneTasksCount=0;
  int todoTasksCount=0;


  void updateCounters(List<Task> tasks) {
    setState(() {
      allTasksCount = tasks.length;
      doneTasksCount = tasks.where((task) => task.done).length;
      todoTasksCount = tasks.where((task) => !task.done).length;
    });
  }



  @override
  void initState() {
    super.initState();
    tasksFuture = loadTasks();
  }
  Future<List<Task>> loadTasks() async {
    await TaskSyncService.loadInitialDataIfNeeded();
    return TaskLocalDatabase.getTasks();
  }




  @override
  Widget build(BuildContext context) {



// zmienna pomocnicza przetrzymująca obecnie przefiltrowaną listę
    List<Task> filteredTasks = TaskRepository.tasks;

    if (selectedFilter == "wykonane") {
      filteredTasks = TaskRepository.tasks
          .where((task) => task.done)
          .toList();
    } else if (selectedFilter == "do zrobienia") {
      filteredTasks = TaskRepository.tasks
          .where((task) => !task.done)
          .toList();
    }

    var wykonane = 0;

    for (var i = 0; i < TaskRepository.tasks.length; i++) {
      if (TaskRepository.tasks[i].done == true) {
        wykonane = wykonane + 1;
      }
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final Task? newTask = await Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  AddTaskScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                final offsetAnimation = Tween<Offset>(
                  begin: Offset(1.0, -1),  // (1/-1 prawo/lewo) , (1/-1) dół/góra
                  end: Offset.zero,
                ).animate(animation);

                return SlideTransition(
                  position: offsetAnimation,
                  child: child,
                );
              },
            ),
          );

          if (newTask != null) {
            setState(() {
              TaskRepository.tasks.add(newTask);
            });
          }
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text("KrakFlow"),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Potwierdzenie"),
                    content: Text(
                      "Czy na pewno chcesz usunąć wszystkie zadania?",
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("Anuluj"),
                      ),

                      TextButton(
                        onPressed: () {
                          setState(() {
                            TaskRepository.tasks.clear();
                          });

                          Navigator.pop(context);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Usunięto wszystkie zadania",
                              ),
                            ),
                          );
                        },
                        child: Text("Usuń"),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Masz dziś ${TaskRepository.tasks.length} zadania",
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
              Text(
                "Zostało wykonane: $wykonane",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          Row(
            children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    selectedFilter = "wszystkie";
                  });
                },
                child: Text(
                  "Wszystkie",
                  style: TextStyle(
                    color: selectedFilter == "wszystkie"
                        ? Color.fromARGB(255, 200, 0, 255)
                        : Colors.amber,
                  ),
                ),
              ),

              TextButton(
                onPressed: () {
                  setState(() {
                    selectedFilter = "do zrobienia";
                  });
                },
                child: Text(
                  "Do zrobienia",
                  style: TextStyle(
                    color: selectedFilter == "do zrobienia"
                        ? Color.fromARGB(255, 200, 0, 255)
                        : Colors.amber,
                  ),
                ),
              ),

              TextButton(
                onPressed: () {
                  setState(() {
                    selectedFilter = "wykonane";
                  });
                },
                child: Text(
                  "Wykonane",
                  style: TextStyle(
                    color: selectedFilter == "wykonane"
                        ? Color.fromARGB(255, 200, 0, 255)
                        : Colors.amber,
                  ),
                ),
              ),
            ],
          ),
          Expanded(

              child: FutureBuilder<List<Task>>(
              future: tasksFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text("Błąd: ${snapshot.error}"),
                  );
                }

                final tasks = snapshot.data ?? [];

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  widget.onTasksLoaded(tasks);
                });


                return ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];

                    return TaskCard(
                      title: task.title,
                      subtitle: "termin: ${task.deadline} + priorytet ${task.priority}",
                      done: task.done,
                      Onchanged: (value) async {
                      final updatedTask = Task(
                        id: task.id,
                        title: task.title,
                        deadline: task.deadline,
                        priority: task.priority,
                        done: value ?? false,
                      );
                      await TaskLocalDatabase.updateTask(updatedTask);
                      setState(() {
                        tasksFuture = loadTasks();
                      });
                    },

                    onTap: () async {
                        final Task? updatedTask = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditTaskScreen(task: task),
                          ),
                        );
                        if (updatedTask != null) {
                          await TaskLocalDatabase.updateTask(updatedTask);
                          setState(() {
                            tasksFuture = loadTasks();
                          });
                        }
                      },

                    );
                  },
                );
              },
            ),
          ),
          Expanded(
            child: TaskListScreen(
              onTasksLoaded: updateCounters,
            ),
          )
        ],
      ),
    );
  }
}
class TaskCard extends StatelessWidget {
  final String title;
  final String subtitle;
  bool done;
  final ValueChanged<bool?>? Onchanged;
  final VoidCallback? onTap;


  TaskCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.done,
    this.Onchanged,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        leading: Checkbox(
            value: done,
            onChanged: Onchanged,
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: Icon(Icons.chevron_right),
      ),
    );
  }
}

class AddTaskScreen extends StatelessWidget {
  AddTaskScreen({super.key});

  final TextEditingController titleController = TextEditingController();
  final TextEditingController deadlineController = TextEditingController();
  final TextEditingController priorityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nowe zadanie"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: "Tytuł zadania",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            TextField(
              controller: deadlineController,
              decoration: InputDecoration(
                labelText: "Termin",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            TextField(
              controller: priorityController,
              decoration: InputDecoration(
                labelText: "Priorytet",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                final newTask = Task(
                  title: titleController.text,
                  deadline: deadlineController.text,
                  done: false,
                  priority: priorityController.text,
                );

                Navigator.pop(context, newTask);
              },
              child: Text("Zapisz"),
            ),
          ],
        ),
      ),
    );
  }
}

class EditTaskScreen extends StatelessWidget{
  final Task task;
   EditTaskScreen({
    super.key,
    required this.task,
  });
  final TextEditingController titleController = TextEditingController();
  final TextEditingController deadlineController = TextEditingController();
  final TextEditingController priorityController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edytuj zadanie"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: "Tytuł zadania",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            TextField(
              controller: deadlineController,
              decoration: InputDecoration(
                labelText: "Termin",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            TextField(
              controller: priorityController,
              decoration: InputDecoration(
                labelText: "Priorytet",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                final newTask = Task(
                  title: titleController.text,
                  deadline: deadlineController.text,
                  done: false,
                  priority: priorityController.text,
                );

                Navigator.pop(context, newTask);
              },
              child: Text("Zapisz"),
            ),
          ],
        ),
      ),
    );}}


class Task {
  final int id;
  final String title;
  final String deadline;
  final String priority;
  final bool done;

  Task({
    required this.id,
    required this.title,
    required this.deadline,
    required this.priority,
    required this.done,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "deadline": deadline,
      "priority": priority,
      "done": done,
    };
  }

  factory Task.fromMap(Map map) {
    return Task(
      id: map["id"],
      title: map["title"],
      deadline: map["deadline"],
      priority: map["priority"],
      done: map["done"],
    );
  }
}
class TaskListScreen extends StatefulWidget {
  final ValueChanged<List<Task>> onTasksLoaded;
  const TaskListScreen({
    super.key,
    required this.onTasksLoaded,
  });
  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}
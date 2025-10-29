import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/task_controller.dart';
import '../controllers/auth_controller.dart';
import '../models/task.dart';
import 'quiz_page.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TaskController taskController = Get.put(TaskController());
  final AuthController authController = Get.find();

  late Map<dynamic, dynamic> userMap;
  int userId = 0;
  String username = '';
  String email = '';

  @override
  void initState() {
    super.initState();
    // read user from arguments
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = Get.arguments;
      if (args != null && args is Map) {
        userMap = args;
        userId = userMap['id'] as int;
        username = userMap['username'] as String;
        email = userMap['email'] as String;
        taskController.loadTasks(userId);
        setState((){});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome ${username.isNotEmpty ? username : ''}'),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              // show profile dialog
              Get.dialog(AlertDialog(
                title: Text('Profile'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Name: \$username'),
                    Text('Email: \$email'),
                  ],
                ),
                actions: [
                  TextButton(onPressed: () => Get.back(), child: Text('Close'))
                ],
              ));
            },
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Get.offAllNamed('/login');
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: () {
                if (userId == 0) {
                  Get.snackbar('Error', 'User not found. Login again.');
                  return;
                }
                taskController.generateTask(userId);
              },
              icon: Icon(Icons.add_task),
              label: Text('Generate Task'),
            ),
            SizedBox(height: 16),
            Expanded(
              child: Obx(() {
                final tasks = taskController.tasks;
                if (tasks.isEmpty) {
                  return Center(child: Text('No tasks yet'));
                }
                return ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final Task t = tasks[index];
                    return Card(
                      child: ListTile(
                        title: Text('Task #\${t.id}'),
                        subtitle: Text(t.isCompleted ? 'Already Completed' : 'Tap to start quiz'),
                        trailing: t.isCompleted ? Icon(Icons.check, color: Colors.green) : Icon(Icons.play_arrow),
                        onTap: t.isCompleted ? null : () {
                          Get.to(() => QuizPage(task: t), arguments: {'userId': userId});
                        },
                      ),
                    );
                  },
                );
              }),
            )
          ],
        ),
      ),
    );
  }
}

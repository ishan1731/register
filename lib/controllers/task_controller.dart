import 'dart:convert';
import 'package:get/get.dart';
import '../services/db_service.dart';
import '../models/task.dart';
import 'dart:math';

class TaskController extends GetxController {
  final db = DBService();
  var tasks = <Task>[].obs;

  final List<Map<String, dynamic>> questionBank = [
    {"q": "What is Flutter?", "options": ["Framework", "OS", "Game"], "ans": "Framework"},
    {"q": "Dart is developed by?", "options": ["Google", "Meta", "Microsoft"], "ans": "Google"},
    {"q": "Widget in Flutter?", "options": ["Component", "Variable", "Loop"], "ans": "Component"},
    {"q": "StatefulWidget has?", "options": ["setState()", "main()", "init()"], "ans": "setState()"},
    {"q": "Hot Reload used for?", "options": ["UI update", "App restart", "Cache clear"], "ans": "UI update"},
    {"q": "Which language Flutter uses?", "options": ["Java", "Dart", "Kotlin"], "ans": "Dart"},
    {"q": "Which layout arranges children vertically?", "options": ["Column", "Row", "Stack"], "ans": "Column"},
    {"q": "Navigator used for?", "options": ["Routing", "Animation", "Storage"], "ans": "Routing"},
    {"q": "Flutter is?", "options": ["Open Source", "Paid", "Private"], "ans": "Open Source"},
    {"q": "Best State Management?", "options": ["GetX", "Redux", "Both"], "ans": "Both"},
  ];

  Future<void> loadTasks(int userId) async {
    tasks.value = await db.getTasksByUser(userId);
  }

  Future<void> generateTask(int userId) async {
    // If any incomplete task exists, prevent generating new one
    final existing = await db.getTasksByUser(userId);
    final hasRunning = existing.any((t) => t.isCompleted == false);
    if (hasRunning) {
      Get.snackbar('Alert', 'You already have a running task');
      await loadTasks(userId);
      return;
    }

    // pick 3 random different questions from bank
    final rand = Random();
    final indices = <int>{};
    while (indices.length < 3) {
      indices.add(rand.nextInt(questionBank.length));
    }
    final picked = indices.map((i) => questionBank[i]).toList();
    final encoded = jsonEncode(picked);
    final task = Task(userId: userId, questionsJson: encoded, isCompleted: false);
    await db.createTask(task);
    await loadTasks(userId);
    Get.snackbar('Task', 'New task generated');
  }

  Future<void> markCompleted(int id, int userId) async {
    await db.markTaskCompleted(id);
    await loadTasks(userId);
  }
}

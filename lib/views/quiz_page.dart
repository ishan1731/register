import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/task.dart';
import '../controllers/task_controller.dart';

class QuizPage extends StatefulWidget {
  final Task task;
  QuizPage({required this.task});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final TaskController controller = Get.find();
  late List<dynamic> questions;
  Map<int, String> selected = {};

  late int userId;

  @override
  void initState() {
    super.initState();
    questions = jsonDecode(widget.task.questionsJson);
    final args = Get.arguments;
    userId = (args != null && args is Map && args['userId'] != null) ? args['userId'] as int : 0;
  }

  void _onSelect(int qIndex, String option) {
    if (selected.containsKey(qIndex)) return; // prevent changing answer
    setState(() {
      selected[qIndex] = option;
    });
    // if last question answered, mark completed after short delay
    if (selected.length == questions.length) {
      Future.delayed(Duration(milliseconds: 600), () async {
        await controller.markCompleted(widget.task.id ?? 0, userId);
        Get.snackbar('Completed', 'Task completed');
        Get.back();
      });
    }
  }

  Color _bgColor(int qIndex, String option) {
    if (!selected.containsKey(qIndex)) return Colors.grey.shade200;
    final chosen = selected[qIndex]!;
    final correct = questions[qIndex]['ans'];
    if (option == correct) return Colors.green.shade300;
    if (option == chosen && option != correct) return Colors.red.shade300;
    return Colors.grey.shade200;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task #\${widget.task.id} Quiz'),
      ),
      body: ListView.builder(
        itemCount: questions.length,
        itemBuilder: (context, index) {
          final q = questions[index];
          return Card(
            margin: EdgeInsets.all(12),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('\${index+1}. \${q[\'q\']}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  ...List<Widget>.from((q['options'] as List).map((opt) {
                    return GestureDetector(
                      onTap: () => _onSelect(index, opt),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(12),
                        margin: EdgeInsets.symmetric(vertical: 6),
                        decoration: BoxDecoration(
                          color: _bgColor(index, opt),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(opt),
                      ),
                    );
                  }))
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

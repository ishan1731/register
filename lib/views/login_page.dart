import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/task_controller.dart';
import '../services/db_service.dart';
import '../models/user.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthController controller = Get.put(AuthController());
  final TaskController taskController = Get.put(TaskController());

  @override
  void initState() {
    super.initState();
    controller.tryAutoFillLastRegistered();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: controller.emailController, decoration: InputDecoration(labelText: 'Email')),
            SizedBox(height: 8),
            TextField(controller: controller.passwordController, decoration: InputDecoration(labelText: 'Password'), obscureText: true),
            SizedBox(height: 16),
            Obx(() => controller.isLoading.value ? CircularProgressIndicator() : ElevatedButton(
              onPressed: () async {
                await controller.loginUser();
              },
              child: Text('Login'),
            )),
            TextButton(
              onPressed: () => Get.offAllNamed('/register'),
              child: Text('Don\'t have an account? Register'),
            )
          ],
        ),
      ),
    );
  }
}

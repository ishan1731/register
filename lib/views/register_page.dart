import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

class RegisterPage extends StatelessWidget {
  final AuthController controller = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: controller.usernameController, decoration: InputDecoration(labelText: 'Username')),
              SizedBox(height: 8),
              TextField(controller: controller.emailController, decoration: InputDecoration(labelText: 'Email'), keyboardType: TextInputType.emailAddress),
              SizedBox(height: 8),
              TextField(controller: controller.phoneController, decoration: InputDecoration(labelText: 'Phone'), keyboardType: TextInputType.phone),
              SizedBox(height: 8),
              TextField(controller: controller.passwordController, decoration: InputDecoration(labelText: 'Password'), obscureText: true),
              SizedBox(height: 16),
              Obx(() => controller.isLoading.value ? CircularProgressIndicator() : ElevatedButton(
                onPressed: controller.registerUser,
                child: Text('Register'),
              )),
              TextButton(
                onPressed: () => Get.offAllNamed('/login'),
                child: Text('Already have account? Login'),
              )
            ],
          ),
        ),
      ),
    );
  }
}

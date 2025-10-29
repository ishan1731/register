import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/db_service.dart';
import '../models/user.dart';

class AuthController extends GetxController {
  final db = DBService();

  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();

  var isLoading = false.obs;

  Future<void> tryAutoFillLastRegistered() async {
    final last = await db.getLastRegisteredUser();
    if (last != null) {
      emailController.text = last.email;
      passwordController.text = last.password;
    }
  }

  Future<void> registerUser() async {
    final username = usernameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;
    final phone = phoneController.text.trim();

    if (username.isEmpty || email.isEmpty || password.isEmpty || phone.isEmpty) {
      Get.snackbar('Error', 'Please fill all fields');
      return;
    }
    // basic email validation
    if (!RegExp(r"^[^@\s]+@[^@\s]+\.[^@\s]+").hasMatch(email)) {
      Get.snackbar('Error', 'Enter valid email');
      return;
    }
    if (password.length < 6) {
      Get.snackbar('Error', 'Password must be at least 6 characters');
      return;
    }

    isLoading.value = true;
    final existing = await db.getUserByEmail(email);
    if (existing != null) {
      isLoading.value = false;
      Get.snackbar('Error', 'User already exists with this email');
      return;
    }

    final user = User(username: username, email: email, password: password, phone: phone);
    final id = await db.insertUser(user);
    isLoading.value = false;
    Get.snackbar('Success', 'Registered successfully');
    // autofill login fields by setting last registered in DB (getLastRegisteredUser used on login page)
    Get.offAllNamed('/login');
  }

  Future<void> loginUser() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar('Error', 'Email and password required');
      return;
    }
    isLoading.value = true;
    final user = await db.getUserByEmailAndPassword(email, password);
    isLoading.value = false;
    if (user != null) {
      // go to home
      Get.offAllNamed('/home', arguments: user.toMap());
    } else {
      Get.snackbar('Error', 'Invalid credentials');
    }
  }
}

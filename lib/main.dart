import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'views/login_page.dart';
import 'views/register_page.dart';
import 'views/home_page.dart';
import 'views/quiz_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Auth Task Quiz',
      debugShowCheckedModeBanner: false,
      initialRoute: '/register',
      getPages: [
        GetPage(name: '/register', page: () => RegisterPage()),
        GetPage(name: '/login', page: () => LoginPage()),
        GetPage(name: '/home', page: () => HomePage()),
        // Quiz page uses Get.to with arguments
      ],
    );
  }
}

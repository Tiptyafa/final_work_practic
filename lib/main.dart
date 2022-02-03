import 'package:final_project/model//theme.dart';
import 'package:flutter/material.dart';
import 'package:final_project/screens/auth.dart';
import 'package:final_project/screens/users.dart';
import 'package:final_project/screens/task.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const RScr(),
        '/users': (context) => const UsersScreen(),
        '/tasks': (context) => const TaskScr(),
      },
      title: 'Итог учёбы',
      theme: themePrg(),
    );
  }
}

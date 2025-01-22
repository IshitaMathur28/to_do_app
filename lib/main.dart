import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/todo_home_page.dart';
import 'package:flutter_application_1/theme_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        //theme provider
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: const ToDoApp(),
    ),
  );
}

class ToDoApp extends StatelessWidget {
  const ToDoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const ToDoHomePage(),
      theme: Provider.of<ThemeProvider>(context).themeData);
  }
}

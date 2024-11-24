import 'package:flutter/material.dart';

import 'Principal.dart';

class MyApp extends StatelessWidget {
  final String userEmail;

  const MyApp({required this.userEmail, super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Principal(userEmail: userEmail),
    );
  }
}
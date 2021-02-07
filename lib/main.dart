import 'package:flutter/material.dart';

import 'ui/login_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(theme: ThemeData.dark(), home: const LoginScreen());
}

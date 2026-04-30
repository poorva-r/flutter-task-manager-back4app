import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the Parse/Back4App connection
  await Parse().initialize(
    'VluLQJAY9kdrSDGTafXJ9wSfbiXvXpIufDnu1Z72',
    'https://parseapi.back4app.com',
    clientKey: 'E8iVyXYUv2BxTvN8noXmroYa9JqJcfP84K750K7M',
    autoSendSessionId:
        true, // auto send session token with every request - keeps user logged in
    debug: true,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const LoginScreen(),
    );
  }
}
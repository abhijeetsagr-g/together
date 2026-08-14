import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:together/firebase_options.dart';
import 'package:together/feature/screen/home_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const TogetherApp());
}

class TogetherApp extends StatelessWidget {
  const TogetherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: HomeView());
  }
}

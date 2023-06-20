import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'pages/my_home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // ensure flutter framework is initialized
  await Supabase.initialize(
    url: 'https://<your_project_id>.supabase.co', // provide your project url here
    anonKey: '<your_anon_key>', // provide your anon key here
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Supabase Auth Demo'),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'pages/my_home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://uvaqnjsyudgxpdjolimd.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InV2YXFuanN5dWRneHBkam9saW1kIiwicm9sZSI6ImFub24iLCJpYXQiOjE2ODY2OTYwNjQsImV4cCI6MjAwMjI3MjA2NH0.-HhQc_Iz7PUyZgOGcZc09ebtxhvug_yFhLDYhECHd4k',
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

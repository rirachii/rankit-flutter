import 'package:flutter/material.dart';

import './screens/login_screen.dart';
import './screens/home_screen.dart';
import './screens/create_list_screen.dart';
import './screens/list_screen.dart';
import './screens/profile_screen.dart';

import 'package:supabase/supabase.dart';
// import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'ListData.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(ListDataAdapter());
  await Hive.openBox<ListData>('lists');
  final client = SupabaseClient('https://cnntfqeyntlfqzxjmiof.supabase.co',
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNubnRmcWV5bnRsZnF6eGptaW9mIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDQ1MzY1NjQsImV4cCI6MjAyMDExMjU2NH0.W4-73L6OFku-z8r51hWv0e59SItC2U_4ZD4k-qpnx4w');
  runApp(MyApp(client: client));
}

class MyApp extends StatelessWidget {
  final SupabaseClient client;

  MyApp({required this.client});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: 'home',
      routes: {
        '/': (context) => LoginScreen(client: client),
        '/home': (context) => HomeScreen(),
        '/createList': (context) => CreateListScreen(),
        '/list': (context) => ListScreen(),
        '/profile': (context) => ProfileScreen(),
      },
    );
  }
}

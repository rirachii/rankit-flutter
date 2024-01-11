import 'package:flutter/material.dart';

import './screens/login_screen.dart';
import './screens/home_screen.dart';
import './screens/create_list_screen.dart';
import './screens/list_screen.dart';
import './screens/profile_screen.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase/supabase.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'ListData.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox<ListData>('lists');
  
  // Hive.registerAdapter(MyListDataAdapter());
  // Hive.registerAdapter(MyItemAdapter());

  await dotenv.load(fileName: ".env");
  var apiUrl = dotenv.get('SUPA_URL');
  var apiKey = dotenv.get('API_KEY');

  print(apiUrl);
  final client = SupabaseClient(apiUrl, apiKey);
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
      initialRoute: '/',
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

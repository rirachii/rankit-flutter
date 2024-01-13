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
import 'box.dart' as globalBox;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter<ListData>(ListDataAdapter());
  globalBox.listBox = await Hive.openBox<ListData>('lists');
  // globalBox.listBox = await Hive.box('lists');

  print("starting");
  await dotenv.load(fileName: ".env");
  var apiUrl = dotenv.get("SUPA_URL");
  var apiKey = dotenv.get("API_KEY");
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
      initialRoute: '/home',
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

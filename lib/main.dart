import 'package:flutter/material.dart';
import 'package:rankit_flutter/screens/root_screen.dart';

import 'screens/fb_login_screen.dart';
import './screens/home_screen.dart';
import './screens/create_list_screen.dart';
import './screens/profile_screen.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'ListData.dart';
import 'box.dart' as globalBox;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.ios,
    // options: DefaultFirebaseOptions.currentPlatform,
  );
  await Hive.initFlutter();
  Hive.registerAdapter<ListData>(ListDataAdapter());
  globalBox.listBox = await Hive.openBox<ListData>('lists');
  // globalBox.listBox.clear();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => RootScreen(),
        '/login': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
        '/createList': (context) => CreateListScreen(),
        '/profile': (context) => ProfileScreen(),
      },
    );
  }
}

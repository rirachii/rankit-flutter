import 'package:flutter/material.dart';
import 'package:rankit_flutter/screens/root_screen.dart';

import 'screens/fb_login_screen.dart';
import './screens/home_screen.dart';
import './screens/create_list_screen.dart';
import './screens/profile_screen.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'objects/list_data.dart';
import '../objects/item.dart';
import 'objects/box.dart' as global_box;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.ios,
    // options: DefaultFirebaseOptions.currentPlatform,
  );
  await Hive.initFlutter();
  Hive.registerAdapter<ListData>(ListDataAdapter());
  Hive.registerAdapter<Item>(ItemAdapter());
  global_box.listBox = await Hive.openBox<ListData>('lists');
  global_box.listBox.clear();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const RootScreen(),
        '/login': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
        '/createList': (context) => const CreateListScreen(),
        '/profile': (context) => ProfileScreen(),
      },
      scaffoldMessengerKey: scaffoldMessengerKey,

    );
  }
}

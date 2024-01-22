import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rankit_flutter/service/connectivity_service.dart';
import 'create_list_screen.dart';
import 'edit_list_screen.dart';
import 'rank_screen.dart';
import 'list_reorder_screen.dart';
import 'swipe_screen/swipe_screen.dart';
import '../objects/box.dart' as global_box;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ConnectivityService _connectivityService = ConnectivityService();

  String filter = '';

  @override
  void initState() {
    super.initState();
    _connectivityService.connectivityController.stream.listen((status) {
      if (status == ConnectivityResult.none) {
        String connectionStatus;
        switch (status) {
          case ConnectivityResult.wifi:
            connectionStatus = 'Connected to WiFi';
            break;
          case ConnectivityResult.mobile:
            connectionStatus = 'Connected to Mobile Network';
            break;
          case ConnectivityResult.none:
            connectionStatus = 'No Internet Connection';
            break;
          default:
            connectionStatus = 'Internet Connection Status Unknown';
            break;
        }
      ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(connectionStatus),
        duration: const Duration(seconds: 3),
      ),
      );}
    });

    print('started');
  }

  @override
  void dispose() {
    _connectivityService.connectivityController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          onChanged: (value) {
            setState(() {
              filter = value;
            });
          },
          decoration: const InputDecoration(hintText: 'Search...'),
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: global_box.listBox.listenable(),
        builder: (context, Box<dynamic> box, _) {
          var lists = box.values
              .where((list) => list.listName.contains(filter))
              .toList();
          return ListView.builder(
            itemCount: lists.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SwipeScreen(
                        listId: lists[index].listId,
                      ),
                    ),
                  );
                },
                child: ListTile(
                  title: Text(lists[index].listName),
                  subtitle: Text(lists[index].listDescription),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditListScreen(
                            listId: lists[index].listId,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateListScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

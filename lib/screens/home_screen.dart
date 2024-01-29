import 'package:flutter/material.dart';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:rankit_flutter/objects/list_data.dart';
import 'package:rankit_flutter/screens/list_screen_test/animated_list_screen%20copy.dart';
import 'package:rankit_flutter/screens/list_screen_test/animated_list_screen.dart';
import 'package:rankit_flutter/screens/tournament_screen.dart';
import 'package:rankit_flutter/service/connectivity_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  final Stream<QuerySnapshot> _listItemsStream = FirebaseFirestore.instance.collection('Public Lists').snapshots();

  String filter = '';

  @override
  void initState() {
    super.initState();

    

    // _connectivityService.connectivityController.stream.listen((status) {
    //   if (status == ConnectivityResult.none) {
    //     String connectionStatus;
    //     switch (status) {
    //       case ConnectivityResult.wifi:
    //         connectionStatus = 'Connected to WiFi';
    //         break;
    //       case ConnectivityResult.mobile:
    //         connectionStatus = 'Connected to Mobile Network';
    //         break;
    //       case ConnectivityResult.none:
    //         connectionStatus = 'No Internet Connection';
    //         break;
    //       default:
    //         connectionStatus = 'Internet Connection Status Unknown';
    //         break;
    //     }
    //   ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     content: Text(connectionStatus),
    //     duration: const Duration(seconds: 3),
    //   ),
    //   );}
    // });

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
      body:StreamBuilder<QuerySnapshot>(
      stream: _listItemsStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          
          // List<ListData> lists = box.values
          //     .where((list) => list.listName.contains(filter))
          //     .toList();
          List<ListData> lists = snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
            return ListData.fromMap(data);
          }).where((list) => list.listName.contains(filter)).toList();
          

          return ListView.builder(
            itemCount: lists.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TournamentScreen(
                        listData: lists[index],
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
                            listData: lists[index],
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

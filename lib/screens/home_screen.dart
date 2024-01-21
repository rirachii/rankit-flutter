import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'create_list_screen.dart';
import 'edit_list_screen.dart';
import 'rank_screen.dart';
import 'list_reorder_screen.dart';
import 'swipe_screen/swipe_screen.dart';
import '../objects/list_data.dart';
import '../objects/box.dart' as global_box;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String filter = '';

  @override
  void initState() {
    super.initState();
    print('started');
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
            MaterialPageRoute(builder: (context) => CreateListScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

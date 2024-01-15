import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../ListData.dart';
import 'create_list_screen.dart';
import 'edit_list_screen.dart';
import 'rank_screen.dart';
import '../box.dart' as globalBox;

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
          decoration: InputDecoration(hintText: 'Search...'),
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: globalBox.listBox.listenable(),
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
                      builder: (context) => RankScreen(
                        listId: lists[index].listId,
                      ),
                    ),
                  );
                },
                child: ListTile(
                  title: Text(lists[index].listName),
                  subtitle: Text(lists[index].listDescription),
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
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
        child: Icon(Icons.add),
      ),
    );
  }
}

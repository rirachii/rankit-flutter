import 'package:flutter/material.dart';
import 'package:implicitly_animated_reorderable_list_2/implicitly_animated_reorderable_list_2.dart';
import 'package:implicitly_animated_reorderable_list_2/transitions.dart';
import 'dart:ui';

import '../box.dart' as globalBox;

class RankScreen extends StatefulWidget {
  final String listId;

  const RankScreen({Key? key, required this.listId}) : super(key: key);

  @override
  _RankScreenState createState() => _RankScreenState();
}

class _RankScreenState extends State<RankScreen> {
  late String listName;
  late String listDescription;
  // late List<Map<String, String>> _items;
  late List<Widget> _items;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final listObject = globalBox.listBox.get(widget.listId);
    listName = listObject.listName;
    listDescription = listObject.listDescription;
    // _items = listObject.items;
    final items = listObject.items;
    setState(() {
      _items = items
        .map((item) => ListTile(
          key: Key(item['itemId']!),
          title: Text(item['itemName']!),
        ))
        .toList();
    });
  }

  Future<bool> _onReorder(int oldIndex, int newIndex) async {
    setState(() {
      int oldValue = _items[oldIndex];
      _items.removeAt(oldIndex);
      _items.insert(newIndex, oldValue);
    });
    _saveItems();
    return true;
  }

  Future<void> _saveItems() async {
    final box = await Hive.openBox<int>('myBox');
    await box.clear();
    for (var item in _items) {
      await box.add(item);
    }
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Rank Screen'),
    ),
    body: ReorderableList(
      onReorder: _onReorder,
      child: ListView.builder(
        itemCount: _items.length,
        itemBuilder: (BuildContext context, int index) {
          return ReorderableItem(
            key: Key(_items[index]['itemId']!),
            childBuilder: (BuildContext context, ReorderableItemState state) {
              return Container(
                child: ListTile(
                  title: Text('Rank ${index + 1}: Item ${_items[index]['itemName']}'),
                  leading: ReorderableListener(
                    child: Icon(Icons.drag_handle),
                  ),
                ),
              );
            },
          );
        },
      ),
    ),
  );
}

}
import 'package:flutter/material.dart';
import 'package:implicitly_animated_reorderable_list_2/implicitly_animated_reorderable_list_2.dart';
import 'package:implicitly_animated_reorderable_list_2/transitions.dart';

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

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rank Screen'),
      ),
      body: ImplicitlyAnimatedReorderableList<int>(
        items: _items,
        areItemsTheSame: (oldItem, newItem) => oldItem == newItem,
        onReorderFinished: (item, from, to, newItems) {
          setState(() {
            _items
              ..clear()
              ..addAll(newItems);
          });
          _saveItems();
        },
        itemBuilder: (context, itemAnimation, item, index) {
          return Reorderable(
            key: ValueKey(item),
            builder: (context, dragAnimation, inDrag) {
              return SizeFadeTransition(
                sizeFraction: 0.7,
                curve: Curves.easeInOut,
                animation: itemAnimation,
                child: Material(
                  child: ListTile(
                    title: Text('Item $item'),
                    leading: ReorderableHandle(
                      child: Icon(Icons.drag_handle),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

}
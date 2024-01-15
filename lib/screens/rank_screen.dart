import 'package:flutter/material.dart';

class RankScreen extends StatefulWidget {
  final String listId;

  RankScreen({required this.listId});

  @override
  _RankScreenState createState() => _RankScreenState();
}

class _RankScreenState extends State<RankScreen> {
  List<String> items = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rank Screen'),
      ),
      body: ReorderableListView(
        onReorder: (oldIndex, newIndex) {
          setState(() {
            if (newIndex > oldIndex) {
              newIndex -= 1;
            }
            final item = items.removeAt(oldIndex);
            items.insert(newIndex, item);
          });
        },
        children: items
            .map((item) => ListTile(
                  key: Key(item),
                  title: Text(item),
                ))
            .toList(),
      ),
    );
  }
}

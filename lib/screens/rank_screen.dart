import 'package:flutter/material.dart';
import 'package:flutter_reorderable_grid_view/entities/order_update_entity.dart';
import 'package:flutter_reorderable_grid_view/widgets/widgets.dart';
import '../objects/box.dart' as global_box;

class RankScreen extends StatefulWidget {
  final String listId;

  const RankScreen({super.key, required this.listId});

  @override
  _RankScreenState createState() => _RankScreenState();
}

class _RankScreenState extends State<RankScreen> {
  final _scrollController = ScrollController();
  final _gridViewKey = GlobalKey();
  late String listName;
  late String listDescription;
  late List<Map<String, String>> itemFields;

  @override
  void initState() {
    super.initState();
    final listObject = global_box.listBox.get(widget.listId);
    listName = listObject.listName;
    listDescription = listObject.listDescription;
    itemFields = listObject.items;
  }

  @override
  Widget build(BuildContext context) {
    final generatedChildren = List.generate(
      itemFields.length,
      (index) => Container(
        key: Key(itemFields[index]['itemId']!),
        color: Color.fromARGB(255, 27, 159, 221),
        child: Text(
          itemFields[index]['itemName']!,
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rank list'),
      ),
      body: ReorderableBuilder(
        scrollController: _scrollController,
        onReorder: (List<OrderUpdateEntity> orderUpdateEntities) {
          for (final orderUpdateEntity in orderUpdateEntities) {
            final itemField = itemFields.removeAt(orderUpdateEntity.oldIndex);
            itemFields.insert(orderUpdateEntity.newIndex, itemField);
          }
        },
        builder: (children) {
          return GridView(
            key: _gridViewKey,
            controller: _scrollController,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 10,
              mainAxisSpacing: 10,
              crossAxisSpacing: 5,
            ),
            children: children,
          );
        },
        children: generatedChildren,
      ),
    );
  }
}

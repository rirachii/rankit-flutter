import 'package:flutter/material.dart';
import 'package:flutter_reorderable_grid_view/entities/order_update_entity.dart';
import 'package:flutter_reorderable_grid_view/widgets/widgets.dart';
import '../box.dart' as globalBox;

class RankScreen extends StatefulWidget {
  final String listId;

  const RankScreen({super.key, required this.listId});

  @override
  _RankScreenState createState() => _RankScreenState();
}

enum ViewMode {
  list,
  grid,
  tour,
}

class _RankScreenState extends State<RankScreen> {
  final ViewMode _currentView = ViewMode.list;
  final _scrollController = ScrollController();
  final _gridViewKey = GlobalKey();
  final _fruits = <String>["apple", "banana", "strawberry"];
  late String listName;
  late String listDescription;
  late List<Map<String, String>> itemFields;

  @override
  void initState() {
    super.initState();
    final listObject = globalBox.listBox.get(widget.listId);
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
                  final fruit = _fruits.removeAt(orderUpdateEntity.oldIndex);
                  _fruits.insert(orderUpdateEntity.newIndex, fruit);
                }
              },
              builder: (children) {
                return _buildBody(children);
              },
              children: generatedChildren,
            ),
          );
        }

        Widget _buildBody(List<Widget> children) {
          if (_currentView == ViewMode.list) {
            return ListView(
              controller: _scrollController,
              children: children,
            );
          } else if (_currentView == ViewMode.grid) {
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
          } else {
            return Container(); // Empty container for tour view
          }
        }
      }
        // Body: ReorderableBuilder(){
        // scrollController: _scrollController,
        // onReorder: (List<OrderUpdateEntity> orderUpdateEntities) {
        //   for (final orderUpdateEntity in orderUpdateEntities) {
        //     final fruit = _fruits.removeAt(orderUpdateEntity.oldIndex);
        //     _fruits.insert(orderUpdateEntity.newIndex, fruit);
        //   }
        // },
        // builder: (children) {
        //   return GridView(
        //     key: _gridViewKey,
        //     controller: _scrollController,
        //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        //       crossAxisCount: 10,
        //       mainAxisSpacing: 10,
        //       crossAxisSpacing: 5,
        //     ),
        //     children: children,
        //   );
        // },
        // children: generatedChildren,
//       ),
//     );
//   }
// }
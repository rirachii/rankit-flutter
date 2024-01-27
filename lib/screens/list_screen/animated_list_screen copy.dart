import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:implicitly_animated_reorderable_list_2/implicitly_animated_reorderable_list_2.dart';
import 'package:rankit_flutter/objects/item.dart';
import 'package:rankit_flutter/objects/list_data.dart';
import 'package:implicitly_animated_reorderable_list_2/transitions.dart';

import 'utils/box.dart';

class AnimatedListScreen extends StatefulWidget {
  final ListData listData;

  const AnimatedListScreen({Key? key, required this.listData}) : super(key: key);

  @override
  _AnimatedListScreenState createState() => _AnimatedListScreenState();
}


class _AnimatedListScreenState extends State<AnimatedListScreen> {
  late List<Item> _items;
  final Map<String, int> ranks = {};
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _items = widget.listData.items;
    int i = 0;
    for (Item item in _items) {
      item.setRank = ValueKey(i);
      ranks[item.id] = i;
      i++;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Ranking'),
        backgroundColor: Colors.yellow.shade800,
        // actions: <Widget>[
        //   _buildPopupMenuButton(textTheme),
        // ],
      ),
      body: ImplicitlyAnimatedReorderableList<Item>(
      items: _items,
      shrinkWrap: true,
      reorderDuration: const Duration(milliseconds: 200),
      liftDuration: const Duration(milliseconds: 300),
      physics: const ScrollPhysics(),
      padding: EdgeInsets.zero,
      onReorderFinished: (item, from, to, newItems) {
        // Update the underlying data when the item has been reordered!
        setState(() {
          _items
            ..clear()
            ..addAll(newItems);
        });
      },
      areItemsTheSame: (a, b) => a.id == b.id,
      itemBuilder: (context, itemAnimation, item, index) {
        // Each item must be wrapped in a Reorderable widget.
        return Reorderable(
          key: ValueKey(item.getRank),
          builder: (context, dragAnimation, inDrag) {
            final tile = Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _buildTile(item),
                const Divider(height: 0),
              ],
            );

            return AnimatedBuilder(
              animation: dragAnimation,
              builder: (context, _) {
                final t = dragAnimation.value;
                final color = Color.lerp(Colors.white, Colors.grey.shade100, t);

                return Material(
                  color: color,
                  elevation: lerpDouble(0, 8, t)!,
                  child: SizeFadeTransition(
                    sizeFraction: 0.7,
                    curve: Curves.easeInOut,
                    animation: itemAnimation,
                    child: Material(
                        color: color,
                        elevation: lerpDouble(0, 8, t)!,
                        type: MaterialType.transparency,
                        child: tile
                      ),
                  ));
              }
            );
          },
        );
      },
      updateItemBuilder: (context, itemAnimation, item) {
        return Reorderable(
          key: ValueKey(item.getRank),
          builder: (context, dragAnimation, inDrag) {
            final tile = Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _buildTile(item),
                const Divider(height: 0),
              ],
            );

            return AnimatedBuilder(
              animation: dragAnimation,
              builder: (context, _) {
                final t = dragAnimation.value;
                final color = Color.lerp(Colors.white, Colors.grey.shade100, t);

                return Material(
                  color: color,
                  elevation: lerpDouble(0, 8, t)!,
                  child: FadeTransition(
                    opacity: itemAnimation,
                    child: tile,
                  )
                );
              },
            );
          },
        );
      },
    ));
  }

  Widget _buildTile(Item item) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Slidable(
      child: Container(
        alignment: Alignment.center,
        child: ListTile(
          title: Text(
            item.name,
            style: textTheme.bodyMedium?.copyWith(
              fontSize: 16,
            ),
          ),
          subtitle: Text(
            item.description,
            style: textTheme.bodyLarge?.copyWith(
              fontSize: 15,
            ),
          ),
          leading: SizedBox(
            width: 36,
            height: 36,
            child: Center(
              child: Text(
                '${_items.indexOf(item) + 1}',
                style: textTheme.bodyMedium?.copyWith(
                  color: Colors.indigo,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          trailing: const Handle(
            delay: Duration(milliseconds: 0),
            capturePointer: true,
            child: Icon(
              Icons.drag_handle,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

}


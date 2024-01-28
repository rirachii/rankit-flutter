import 'dart:ui';

import 'package:animated_list_plus/animated_list_plus.dart';
import 'package:animated_list_plus/transitions.dart';
import 'package:flutter/material.dart';
import 'package:rankit_flutter/objects/item.dart';
import 'package:rankit_flutter/objects/list_data.dart';

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
          // Each item must have a unique key.
          key: ValueKey(item),
          // The animation of the Reorderable builder can be used to
          // change to appearance of the item between dragged and normal
          // state. For example to add elevation. Implicit animation are
          // not yet supported.
          builder: (context, dragAnimation, inDrag) {
            final t = dragAnimation.value;

            final elevation = lerpDouble(0, 8, t);
            final color = Color.lerp(Colors.white, Colors.white.withOpacity(0.8), t);

            return SizeFadeTransition(
              sizeFraction: 0.7,
              curve: Curves.easeInOut,
              animation: itemAnimation,
              child: Material(
                color: color,
                elevation: elevation!,
                type: MaterialType.transparency,
                child: ListTile(
                  title: Text(item.name),
                  // The child of a Handle can initialize a drag/reorder.
                  // This could for example be an Icon or the whole item itself. You can
                  // use the delay parameter to specify the duration for how long a pointer
                  // must press the child, until it can be dragged.
                  trailing: Handle(
                    delay: const Duration(milliseconds: 100),
                    child: Icon(
                      Icons.list,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    ));
  }
}
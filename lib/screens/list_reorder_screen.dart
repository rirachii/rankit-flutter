import 'dart:ui';

import 'package:animated_list_plus/animated_list_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reorderable_list/flutter_reorderable_list.dart'
    as reorderable;
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:flutter_reorderable_list/flutter_reorderable_list.dart';
import 'package:path/path.dart';
import 'package:rankit_flutter/objects/item.dart';
import 'package:rankit_flutter/objects/list_data.dart';
import 'package:rankit_flutter/objects/user_list_ranking.dart';
import 'package:rankit_flutter/service/firestore_service.dart';
import 'package:uuid/uuid.dart';

class ListReorderScreen extends StatefulWidget {
  final ListData listData;

  const ListReorderScreen({Key? key, required this.listData}) : super(key: key);

  @override
  _ListReorderScreenState createState() => _ListReorderScreenState();
}

enum DraggingMode {
  iOS,
  android,
}

class _ListReorderScreenState extends State<ListReorderScreen> {
  late User user;
  late List<Item> _items;
  // final UserListRanking _userListRanking = UserListRanking();
  final Map<String, int> ranks = {};

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser!;
    _items = widget.listData.items;
    int i = 0;
    for (Item item in _items) {
      item.setRank = ValueKey(i);
      ranks[item.id] = i;
      i++;
    }
  }

  int _indexOfKey(Key key) {
    return _items.indexWhere((Item d) => d.rank == key);
  }


  bool _reorderCallback(Key item, Key newPosition) {
    int draggingIndex = _indexOfKey(item);
    int newPositionIndex = _indexOfKey(newPosition);

    final Item draggedItem = _items[draggingIndex];
    setState(() {
      // debugPrint("Reordering $item -> $newPosition");
      _items.removeAt(draggingIndex);
      _items.insert(newPositionIndex, draggedItem);
    });
    return true;
  }

  void _reorderDone(Key item) {
    // Save the new order to your data source
    // final draggedItem = _items[_indexOfKey(item)];
    // debugPrint("Reordering finished for ${draggedItem.name}}");
    
  }

  void saveRanks() {
    final Map<String, int> ranks = {};
    int i = 0;
    for (Item item in _items) {
      ranks[item.name] = i;
      i++;
    }

    final UserListRanking userListRanking = UserListRanking(
      listId: widget.listData.listId,
      userId: user.uid,
      visibility: "Private",
      ranks: ranks,
      lastUpdated: Timestamp.now()
    );
    
    FirestoreService.create("User Rankings", const Uuid().v1(), userListRanking.toMap());
    print(_items.map((item) => item.name).toList());
    print(ranks);
    // FirestoreService.create("List Rankings", widget.listData.listId, _userListRanking.toMap());
  }

  //
  // Reordering works by having ReorderableList widget in hierarchy
  // containing ReorderableItems widgets
  //

  DraggingMode _draggingMode = DraggingMode.iOS;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: reorderable.ReorderableList(
        onReorder: _reorderCallback,
        onReorderDone: _reorderDone,
        // _saveOrder: _saveOrder,
        child: CustomScrollView(
          cacheExtent: 3000,
          slivers: <Widget>[
            SliverAppBar(
              title: const Text('List Ranking'),
              backgroundColor: Colors.yellow.shade800,
              actions: <Widget>[
                PopupMenuButton<DraggingMode>(
                  initialValue: _draggingMode,
                  onSelected: (DraggingMode mode) {
                    setState(() {
                      _draggingMode = mode;
                    });
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuItem<DraggingMode>>[
                    const PopupMenuItem<DraggingMode>(
                        value: DraggingMode.iOS,
                        child: Text('Button Drag')),
                    const PopupMenuItem<DraggingMode>(
                        value: DraggingMode.android,
                        child: Text('Hold to drag')),
                  ],
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: const Text("Options"),
                  ),
                ),
              ],
              pinned: true,
            ),
            SliverPadding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    final theme = Theme.of(context);
                    final textTheme = theme.textTheme;
                    return Column(
                      children: [
                        
                        Text('${index + 1}'),
                        ListItem(
                          data: _items[index],
                          // first and last attributes affect border drawn during dragging
                          isFirst: index == 0,
                          isLast: index == _items.length - 1,
                          draggingMode: _draggingMode,
                        ),
                      ],
                    );
                  },
                  childCount: _items.length,
                ),
                
              )
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    saveRanks();
                    Navigator.pop(context);
                  },
                  child: const Text('Save Order'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
}


class ListItem extends StatelessWidget {
  const ListItem({
    Key? key,
    required this.data,
    required this.isFirst,
    required this.isLast,
    required this.draggingMode,
  }) : super(key: key);

  final Item data;
  final bool isFirst;
  final bool isLast;
  final DraggingMode draggingMode;

  Widget _buildChild(BuildContext context, ReorderableItemState state) {
  final theme = Theme.of(context);
  final textTheme = theme.textTheme;
  BoxDecoration decoration;

  if (state == ReorderableItemState.dragProxy ||
      state == ReorderableItemState.dragProxyFinished) {
    // slightly transparent background white dragging (just like on iOS)
    decoration = const BoxDecoration(color: Color.fromARGB(235, 255, 255, 255));
  } else {
    bool placeholder = state == ReorderableItemState.placeholder;
    decoration = BoxDecoration(
      border: Border(
        top: isFirst && !placeholder
          ? Divider.createBorderSide(context) //
          : BorderSide.none,
        bottom: isLast && placeholder
          ? BorderSide.none //
          : Divider.createBorderSide(context)),
      color: placeholder ? null : Colors.white);
  }

  // For iOS dragging mode, there will be drag handle on the right that triggers
  // reordering; For android mode it will be just an empty container
  Widget dragHandle = draggingMode == DraggingMode.iOS
      ? ReorderableListener(
          child: Container(
            padding: const EdgeInsets.only(right: 18.0, left: 18.0),
            color: const Color(0x08000000),
            child: const Center(
              child: Icon(Icons.reorder, color: Color(0xFF888888)),
            ),
          ),
        )
      : Container();

  Widget content = Container(
    decoration: decoration,
    child: SafeArea(
        top: false,
        bottom: false,
        child: Opacity(
          // hide content for placeholder
          opacity: state == ReorderableItemState.placeholder ? 0.0 : 1.0,
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                
                Expanded(
                    child: Slidable(
                      endActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                            // An action can be bigger than the others.
                            flex: 2,
                            onPressed: (BuildContext context) {},
                            backgroundColor: const Color(0xFF7BC043),
                            foregroundColor: Colors.white,
                            icon: Icons.archive,
                            label: 'Archive',
                          ),
                          SlidableAction(
                            onPressed: (BuildContext context) {},
                            backgroundColor: const Color(0xFF0392CF),
                            foregroundColor: Colors.white,
                            icon: Icons.save,
                            label: 'Save',
                          ),
                        ],
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        child: ListTile(
                          title: Text(
                            data.name,
                            style: textTheme.bodyMedium?.copyWith(
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Text(
                            data.description,
                            style: textTheme.bodyLarge?.copyWith(
                              fontSize: 15,
                            ),
                          ),
                          // leading: SizedBox(
                          //   width: 36,
                          //   height: 36,
                          //   child: Center(
                          //     child: Text(
                          //       '${_items.indexOf(_items[index]) + 1}',
                          //       style: textTheme.bodyMedium?.copyWith(
                          //         color: Colors.indigo,
                          //         fontSize: 16,
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          // trailing: const Handle(
                          //   delay: Duration(milliseconds: 0),
                          //   capturePointer: true,
                          //   child: Icon(
                          //     Icons.drag_handle,
                          //     color: Colors.grey,
                          //   ),
                          // ),
                        ),
                      ),
                    )
                    // ListTile(
                    //   title: Text(data.name),
                    //   subtitle: Text(data.description),
                    // )
                  ),
                // Triggers the reordering
                dragHandle,
              ],
            ),
          ),
    )),
  );

    // For android dragging mode, wrap the entire content in DelayedReorderableListener
  if (draggingMode == DraggingMode.android) {
    content = DelayedReorderableListener(
      child: content,
    );
  }

    return content;
  }



  @override
  Widget build(BuildContext context) {
    return ReorderableItem(
      key: data.rank!,
      childBuilder: _buildChild
    );
  }
}

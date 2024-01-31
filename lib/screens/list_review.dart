import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reorderable_list/flutter_reorderable_list.dart'
    as reorderable;
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:flutter_reorderable_list/flutter_reorderable_list.dart';
import 'package:rankit_flutter/objects/item.dart';
import 'package:rankit_flutter/objects/list_data.dart';
import 'package:rankit_flutter/objects/user_list_ranking.dart';
import 'package:rankit_flutter/service/firestore_service.dart';
import 'package:uuid/uuid.dart';

class ListReviewScreen extends StatefulWidget {
  final ListData listData;
  final List<Item> items;

  const ListReviewScreen({Key? key, required this.listData, required this.items}) : super(key: key);

  @override
  _ListReorderScreenState createState() => _ListReorderScreenState();
}

class _ListReorderScreenState extends State<ListReviewScreen> {
  late User user;
  late List<Item> _items;
  final Map<String, int> ranks = {};

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser!;
    _items = widget.items;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: reorderable.ReorderableList(
        onReorder: _reorderCallback,
        // _saveOrder: _saveOrder,
        child: CustomScrollView(
          // dragStartBehavior: DragStartDetailsBehavior.down,
          controller: ScrollController(),
          cacheExtent: 3000,
          slivers: <Widget>[
            SliverAppBar(
              title: const Text('Ranking Review'),
              backgroundColor: Colors.yellow.shade800,
              floating: true,
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
                        
                        // Text('${index + 1}'),
                        ListItem(
                          data: _items[index],
                          items: _items,
                          // first and last attributes affect border drawn during dragging
                          isFirst: index == 0,
                          isLast: index == _items.length - 1,
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
                  child: const Text('Reorder'),
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
    required this.items,
    required this.isFirst,
    required this.isLast,
  }) : super(key: key);

  final Item data;
  final List<Item> items;
  final bool isFirst;
  final bool isLast;

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
  // Widget dragHandle = draggingMode == DraggingMode.iOS
  //     ? ReorderableListener(
  //         child: Container(
  //           padding: const EdgeInsets.only(right: 18.0, left: 18.0),
  //           color: const Color(0x08000000),
  //           child: const Center(
  //             child: Icon(Icons.reorder, color: Color(0xFF888888)),
  //           ),
  //         ),
  //       )
  //     : Container();

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
                      closeOnScroll: false,
                      endActionPane: ActionPane(
                        // scrollController: ScrollController(),
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
                          leading: SizedBox(
                            width: 36,
                            height: 36,
                            child: Center(
                              child: Text(
                                '${items.indexOf(data) + 1}',
                                style: textTheme.bodyMedium?.copyWith(
                                  color: Colors.indigo,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
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
                // dragHandle,
              ],
            ),
          ),
      )),
    );

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

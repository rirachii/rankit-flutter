import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:animated_list_plus/animated_list_plus.dart';
import 'package:animated_list_plus/transitions.dart';
import 'package:uuid/uuid.dart';

import 'package:rankit_flutter/objects/item.dart';
import 'package:rankit_flutter/objects/list_data.dart';
import 'package:rankit_flutter/objects/user_list_ranking.dart';
import 'package:rankit_flutter/screens/home_screen.dart';
import 'package:rankit_flutter/service/firestore_service.dart';

import 'utils/box.dart';

// import 'utils/util.dart';

class LanguagePage extends StatefulWidget {
  final ListData listData;

  const LanguagePage({
    Key? key, required this.listData}) : super(key: key);

  @override
  _LanguagePageState createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage>
    with SingleTickerProviderStateMixin {
  static const double _horizontalHeight = 96;
  static const List<String> options = [
    'Shuffle',
    'Test',
  ];

  late List<Item> _items;
  late User user;
  bool inReorder = false;

  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser!;

    _items = widget.listData.items;
    int i = 0;
    for (Item item in _items) {
      item.setRank = ValueKey(i);
      i++;
    }
  }

  

  void onReorderFinished(List<Item> newItems) {
    // scrollController.jumpTo(scrollController.offset);
    setState(() {
      inReorder = false;

      _items
        ..clear()
        ..addAll(newItems);
    });
  }

  void saveRanks() {
    final Map<String, int> ranks = {};
    int i = 0;
    for (Item item in _items) {
      ranks[item.name] = i;
      i++;
    }

    final UserListRanking _userListRanking = UserListRanking(
      listId: widget.listData.listId,
      userId: user.uid,
      visibility: "Private",
      ranks: ranks,
      lastUpdated: Timestamp.now(),
    );
    
    FirestoreService.create("User Rankings", const Uuid().v1(), _userListRanking.toMap());
    print(_items.map((item) => item.name).toList());
    print(ranks);
    // FirestoreService.create("List Rankings", widget.listData.listId, _userListRanking.toMap());
  }

  @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context);
    // final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('List Ranking'),
        backgroundColor: Colors.yellow.shade800,
        // actions: <Widget>[
        //   _buildPopupMenuButton(textTheme),
        // ],
      ),
      body: ListView(
        // controller: scrollController,
        // Prevent the ListView from scrolling when an item is
        // currently being dragged.
        // padding: const EdgeInsets.only(bottom: 24),
        children: <Widget>[
          // _buildHeadline('Vertically'),
          const Divider(height: 0),
          _buildVerticalLanguageList(),
          // _buildHeadline('Horizontally'),
          // _buildHorizontalLanguageList(),
          const SizedBox(height: 100),
          ElevatedButton(
            onPressed: () {
              saveRanks();
              
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  // * An example of a vertically reorderable list.
  Widget _buildVerticalLanguageList() {
    // final theme = Theme.of(context);

    Reorderable buildReorderable( Item item,
      Widget Function(Widget tile) transition) 
    {
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
                child: transition(tile),
              );
            },
          );
        },
      );
    }

    return ImplicitlyAnimatedReorderableList<Item>(
      items: _items,
      shrinkWrap: true,
      reorderDuration: const Duration(milliseconds: 200),
      liftDuration: const Duration(milliseconds: 300),
      physics: const ScrollPhysics(),
      padding: EdgeInsets.zero,
      areItemsTheSame: (oldItem, newItem) => oldItem == newItem,
      onReorderStarted: (item, index) {
        setState(() => inReorder = true);
        // Scroll to the top or bottom of the list when an item is being dragged.
        if (index < _items.length / 2) {
          scrollController.animateTo(
            scrollController.position.minScrollExtent,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
          );
        } else {
          scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
          );
        }
      },
      onReorderFinished: (movedLanguage, from, to, newItems) {
        // Update the underlying data when the item has been reordered!
        onReorderFinished(newItems);
      },
      itemBuilder: (context, itemAnimation, item, index) {
        final t = itemAnimation.value;
        final color = Color.lerp(Colors.white, Colors.white.withOpacity(0.8), t);
        final elevation = lerpDouble(0, 8, t);
        
        return buildReorderable(item, (tile) {
          return SizeFadeTransition(
            sizeFraction: 0.7,
            curve: Curves.easeInOut,
            animation: itemAnimation,
            child: Material(
                color: color,
                elevation: elevation!,
                type: MaterialType.transparency,
                child: tile
              ),
          );
        });
      },
      updateItemBuilder: (context, itemAnimation, item) {
        return buildReorderable(item, (tile) {
          return FadeTransition(
            opacity: itemAnimation,
            child: tile,
          );
        });
      },
      // footer: _buildFooter(context, theme.textTheme),
    );
  }

  Widget _buildHorizontalLanguageList() {
    return Container(
      height: _horizontalHeight,
      alignment: Alignment.center,
      child: ImplicitlyAnimatedReorderableList<Item>(
        items: _items,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        scrollDirection: Axis.horizontal,
        areItemsTheSame: (oldItem, newItem) => oldItem == newItem,
        onReorderStarted: (item, index) => setState(() => inReorder = true),
        onReorderFinished: (item, from, to, newItems) =>
            onReorderFinished(newItems),
        itemBuilder: (context, itemAnimation, item, index) {
          return Reorderable(
            key: ValueKey(item.toString()),
            builder: (context, dragAnimation, inDrag) {
              final t = dragAnimation.value;
              final box = _buildBox(item, t);

              return SizeFadeTransition(
                animation: itemAnimation,
                axis: Axis.horizontal,
                axisAlignment: 1.0,
                curve: Curves.ease,
                child: box,
              );
            },
          );
        },
        updateItemBuilder: (context, itemAnimation, item) {
          return Reorderable(
            key: ValueKey(item.toString()),
            child: FadeTransition(
              opacity: itemAnimation,
              child: _buildBox(item, 0),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTile(Item item) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    // final List<Widget> actions = [
    //   SlideAction(
    //     closeOnTap: true,
    //     color: Colors.redAccent,
    //     onTap: () => setState(() => selectedLanguages.remove(lang)),
    //     child: Center(
    //       child: Column(
    //         mainAxisSize: MainAxisSize.min,
    //         children: <Widget>[
    //           const Icon(
    //             Icons.delete,
    //             color: Colors.white,
    //           ),
    //           const SizedBox(height: 4),
    //           Text(
    //             'Delete',
    //             style: textTheme.bodyText2?.copyWith(
    //               color: Colors.white,
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // ];

    return Slidable(
      // startActionPane: ActionPane(
      //   // A motion is a widget used to control how the pane animates.
      //   motion: const ScrollMotion(),

      //   // A pane can dismiss the Slidable.
      //   dismissible: DismissiblePane(onDismissed: () {}),

      //   // All actions are defined in the children parameter.
      //   children: [
      //     // A SlidableAction can have an icon and/or a label.
      //     SlidableAction(
      //       onPressed: doNothing,
      //       backgroundColor: const Color(0xFFFE4A49),
      //       foregroundColor: Colors.white,
      //       icon: Icons.delete,
      //       label: 'Delete',
      //     ),
      //     SlidableAction(
      //       onPressed: doNothing,
      //       backgroundColor: const Color(0xFF21B7CA),
      //       foregroundColor: Colors.white,
      //       icon: Icons.share,
      //       label: 'Share',
      //     ),
      //   ],
      // ),
      // The end action pane is the one at the right or the bottom side.
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            // An action can be bigger than the others.
            flex: 2,
            onPressed: doNothing,
            backgroundColor: const Color(0xFF7BC043),
            foregroundColor: Colors.white,
            icon: Icons.archive,
            label: 'Archive',
          ),
          SlidableAction(
            onPressed: doNothing,
            backgroundColor: const Color(0xFF0392CF),
            foregroundColor: Colors.white,
            icon: Icons.save,
            label: 'Save',
          ),
        ],
      ),
      child: Container(
        alignment: Alignment.center,
        // For testing different size item. You can comment this line
        // padding: lang.englishName == 'English'
        //     ? const EdgeInsets.symmetric(vertical: 16.0)
        //     : EdgeInsets.zero,
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

  Widget _buildBox(Item item, double t) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    final elevation = lerpDouble(0, 8, t)!;

    return Handle(
      delay: const Duration(milliseconds: 500),
      child: Box(
        height: _horizontalHeight,
        borderRadius: 8,
        border: Border.all(
          color: Colors.grey.shade300,
          width: 2,
        ),
        elevation: elevation,
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        margin: const EdgeInsets.only(right: 8),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                item.name,
                style: textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              Text(
                item.description,
                style: textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget _buildFooter(BuildContext context, TextTheme textTheme) {
  //   return Box(
  //     color: Colors.white,
  //     onTap: () async {
  //       final result = await Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => const LanguageSearchPage(),
  //         ),
  //       );

  //       if (result != null && !selectedLanguages.contains(result)) {
  //         setState(() {
  //           selectedLanguages.add(result);
  //         });
  //       }
  //     },
  //     child: Column(
  //       mainAxisSize: MainAxisSize.min,
  //       children: <Widget>[
  //         ListTile(
  //           leading: const SizedBox(
  //             height: 36,
  //             width: 36,
  //             child: Center(
  //               child: Icon(
  //                 Icons.add,
  //                 color: Colors.grey,
  //               ),
  //             ),
  //           ),
  //           title: Text(
  //             'Add a language',
  //             style: textTheme.bodyText1?.copyWith(
  //               fontSize: 16,
  //             ),
  //           ),
  //         ),
  //         const Divider(height: 0),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildHeadline(String headline) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    Widget buildDivider() => Container(
          height: 2,
          color: Colors.grey.shade300,
        );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 16),
        buildDivider(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Text(
            headline,
            style: textTheme.bodyText1?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        buildDivider(),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildPopupMenuButton(TextTheme textTheme) {
    return PopupMenuButton<String>(
      padding: const EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      onSelected: (value) {
        switch (value) {
          case 'Shuffle':
            setState(_items.shuffle);
            break;
          case 'Test':
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => HomeScreen(),
              ),
            );
            break;
        }
      },
      itemBuilder: (context) => options.map((option) {
        return PopupMenuItem(
          value: option,
          child: Text(
            option,
            style: textTheme.bodyText1,
          ),
        );
      }).toList(),
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }



  void doNothing(BuildContext context) {
    return;
  }
}

class Pair<A, B> {
  final A first;
  final B second;
  Pair(
    this.first,
    this.second,
  );
}
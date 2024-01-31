import 'package:flutter/material.dart';
import 'package:rankit_flutter/objects/item.dart';
import 'package:rankit_flutter/objects/list_data.dart';
import 'package:rankit_flutter/screens/list_reorder_screen.dart';
import 'package:rankit_flutter/screens/list_review.dart';

class TournamentScreen extends StatefulWidget {
  final ListData listData;
  // final Map<String, List<Item>> groupedItem;

  const TournamentScreen({super.key, required this.listData});

  @override
  _TournamentScreenState createState() => _TournamentScreenState();
}

class _TournamentScreenState extends State<TournamentScreen> {
  late ListData listData = widget.listData;
  late List<Item> remainingItems;
  late List<Item> rankedItems;
  var stack = Stack<int>(initialItems: [4, 3, 2, 1]);

  Map<int, Color> rankColor = {
    0: Colors.white,
    1: const Color.fromARGB(255, 223, 136, 239),
    2: const Color.fromARGB(255, 43, 215, 106),
    3: const Color.fromARGB(255, 255, 210, 85),
    4: const Color.fromARGB(255, 255, 96, 96),
  };
  Map<int, int> widgetColor = {
    0: 0,
    1: 0,
    2: 0,
    3: 0,
  };
  

  @override
  void initState() {
    super.initState();
    remainingItems = List.from(widget.listData.items);
    rankedItems = [];
  }

  void rankItem(Item item, i) {
    if (stack.isEmpty) {
      // remainingItems.remove(value)
      stack.pushAll([4, 3, 2, 1]);
    }
    setState(() {
      print(stack.length);
      if (stack.length == 4) {
        stack.removeAll();
        stack.pushAll([4, 3, 2, 1]);
      }
      if (widgetColor[i] == 0) {
        int rank = stack.pop();
        widgetColor[i] = rank;
      } else {
        stack.push(widgetColor[i]!);
        widgetColor[i] = 0;
      }
      // remainingItems.remove(item);
      // rankedItems.insert(0, item);
    });

    if (remainingItems.length < 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ListReviewScreen(
            listData: listData, 
            items: rankedItems,
          ),
        ),
      );
    }
  }

  // void binarySearch(List<Item> arr, int target) {
  //   int left = 0;
  //   int right = arr.length - 1;

  //   while (left <= right) {
  //     int mid = left + ((right - left) >> 1);

  //     if (arr[mid] is better than target) {
  //       left = mid + 1;
  //     } else if (arr[mid] is worse than target){
  //       right = mid - 1;
  //     } else {
  //       arr.insert(mid, target)
  //     }
  //   }

  //   return;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tournament')),
      body: remainingItems.length >= 2
        ? Column(
          children: <Widget>[
            const Text('Which do you prefer?'),
            for (var pos = 0; pos < 4; pos++)
              ListTile(
                tileColor: rankColor[widgetColor[pos]],
                title: Text(remainingItems[pos].name),
                subtitle: Text(remainingItems[pos].description),
                onTap: () => rankItem(remainingItems[pos], pos),
              ),
          ],
        )
        : const Center(child: Text('Tournament complete!')),
    );
  }
}



class Stack<T> {
  final List<T> _items;

  Stack({List<T>? initialItems})
      : _items = initialItems ?? [];

  void push(T item) {
    _items.add(item);
  }

  void pushAll(List<T> items) {
    _items.addAll(items);
  }

  T pop() {
    final item = _items.last;
    _items.removeLast();
    return item;
  }

  void removeAll() {
    _items.removeRange(0, _items.length);
  }

  int get length {
    return _items.length;
  }

  bool get isEmpty {
    return _items.isEmpty;
  }
}
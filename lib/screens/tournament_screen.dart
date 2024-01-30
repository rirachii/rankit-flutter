import 'package:flutter/material.dart';
import 'package:rankit_flutter/objects/item.dart';
import 'package:rankit_flutter/objects/list_data.dart';
import 'package:rankit_flutter/screens/list_reorder_screen.dart';
import 'package:rankit_flutter/screens/list_review.dart';

class TournamentScreen extends StatefulWidget {
  final ListData listData;

  const TournamentScreen({super.key, required this.listData});

  @override
  _TournamentScreenState createState() => _TournamentScreenState();
}

class _TournamentScreenState extends State<TournamentScreen> {
  late ListData listData = widget.listData;
  late List<Item> remainingItems;
  late List<Item> rankedItems;
  Map<int, Color> colors = {
    0: Colors.white,
    1: Colors.white,
    2: Colors.white,
    3: Colors.white,
  };

  @override
  void initState() {
    super.initState();
    remainingItems = List.from(widget.listData.items);
    rankedItems = [];
  }

  void rankItem(Item item, i) {
    setState(() {
      // remainingItems.remove(item);
      // rankedItems.insert(0, item);
      colors[i] = Colors.green;
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
            for (var i = 0; i < 4; i++)
              ListTile(
                tileColor: colors[i],
                title: Text(remainingItems[i].name),
                subtitle: Text(remainingItems[i].description),
                onTap: () => rankItem(remainingItems[i], i),
              ),
          ],
        )
        : const Center(child: Text('Tournament complete!')),
    );
  }
}
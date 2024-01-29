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

  @override
  void initState() {
    super.initState();
    remainingItems = List.from(widget.listData.items);
    rankedItems = [];
  }

  void rankItem(Item item) {
    setState(() {
      remainingItems.remove(item);
      rankedItems.insert(0, item);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tournament')),
      body: remainingItems.length >= 2
        ? Column(
          children: <Widget>[
            const Text('Which do you prefer?'),
            for (var i = 0; i < 2; i++)
              ListTile(
                title: Text(remainingItems[i].name),
                subtitle: Text(remainingItems[i].description),
                onTap: () => rankItem(remainingItems[i]),
              ),
          ],
        )
        : const Center(child: Text('Tournament complete!')),
    );
  }
}
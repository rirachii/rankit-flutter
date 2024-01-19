// import 'package:flutter/material.dart';
// import 'package:flutter_reorderable_list/flutter_reorderable_list.dart' as reorderable;

// class TierListScreen extends StatefulWidget {
//   @override
//   _TierListScreenState createState() => _TierListScreenState();
// }

// class _TierListScreenState extends State<TierListScreen> {
//   List<List<String>> tiers = [
//     ['Item 1', 'Item 2'],
//     ['Item 3', 'Item 4'],
//     ['Item 5', 'Item 6'],
//     ['Item 7', 'Item 8'],
//     ['Item 9', 'Item 10'],
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Tier List Screen'),
//       ),
//       body: ListView.builder(
//         itemCount: tiers.length,
//         itemBuilder: (context, index) {
//           return Column(
//             children: [
//               Text('Tier ${index + 1}'),
//               reorderable.ReorderableList(
//                 onReorder: (oldIndex, newIndex) => _onReorder(index, oldIndex, newIndex),
//                 child: Column(
//                   children: tiers[index].map((item) => ReorderableItem(
//                     key: Key(item),
//                     childBuilder: (BuildContext context, ReorderableItemState state) {
//                       return ListTile(
//                         title: Text(item),
//                         leading: ReorderableListener(
//                           child: Icon(Icons.drag_handle),
//                         ),
//                       );
//                     },
//                   )).toList(),
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }

//   _onReorder(int tierIndex, int oldIndex, int newIndex) {
//     setState(() {
//       final String item = tiers[tierIndex][oldIndex];
//       tiers[tierIndex].removeAt(oldIndex);
//       tiers[tierIndex].insert(newIndex, item);
//     });
//   }
// }
import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../ListData.dart';
import 'create_list_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Box<ListData> listBox;
  String filter = '';

  @override
  void initState() {
    super.initState();
    listBox = Hive.box<ListData>('lists');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          onChanged: (value) {
            setState(() {
              filter = value;
            });
          },
          decoration: InputDecoration(hintText: 'Search...'),
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: listBox.listenable(),
        builder: (context, Box<ListData> box, _) {
          var lists =
              box.values.where((list) => list.title.contains(filter)).toList();
          return ListView.builder(
            itemCount: lists.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(lists[index].title),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateListScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

// class HomeScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             ElevatedButton(
//               child: Text('Create List'),
//               onPressed: () {
//                 Navigator.pushNamed(context, '/createList');
//               },
//             ),
//             ElevatedButton(
//               child: Text('View List'),
//               onPressed: () {
//                 Navigator.pushNamed(context, '/list');
//               },
//             ),
//             ElevatedButton(
//               child: Text('Profile'),
//               onPressed: () {
//                 Navigator.pushNamed(context, '/profile');
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import '../ListData.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import '../box.dart' as globalBox;

class EditListScreen extends StatefulWidget {
  final String listId;

  EditListScreen({required this.listId});

  @override
  _EditListScreenState createState() => _EditListScreenState();
}

class _EditListScreenState extends State<EditListScreen> {
  late String listName;
  late String listDescription;

  @override
  void initState() {
    super.initState();
    // Fetch list data using widget.listId and update listName and listDescription
    // You can use a state management solution like Provider or Riverpod to handle data fetching and state updates

    // Get the Hive box object

    // Get the list object from the box using widget.listId
    print(widget.listId);
    final listObject = globalBox.listBox.get(widget.listId);

    // Update the listName and listDescription with the values from the list object
    listName = listObject['name'];
    listDescription = listObject['description'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit List'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'List Name',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            TextFormField(
              initialValue: listName,
              onChanged: (value) {
                setState(() {
                  listName = value;
                });
              },
            ),
            SizedBox(height: 16.0),
            Text(
              'List Description',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            TextFormField(
              initialValue: listDescription,
              onChanged: (value) {
                setState(() {
                  listDescription = value;
                });
              },
            ),
            SizedBox(height: 16.0),
            Text(
              'Items',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            // Display the list of items and allow updating their names and descriptions
            // You can use ListView.builder or any other widget to display the items
          ],
        ),
      ),
    );
  }
}

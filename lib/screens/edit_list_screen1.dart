import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import '../ListData.dart';
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
  late List<Map<String, String>> listItems;

  @override
  void initState() {
    super.initState();

    final listObject = globalBox.listBox.get(widget.listId);
    listName = listObject.listName;
    listDescription = listObject.listDescription;
    listItems = listObject.items;
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
            ListView.builder(
              shrinkWrap: true,
              itemCount: listItems.length,
              itemBuilder: (context, index) {
                Map<String, String> item = listItems[index];
                String itemName = item["itemName"] ?? '';
                String itemDescription = item["itemDescription"] ?? '';

                return ListTile(
                  title: Text(itemName),
                  subtitle: Text(itemDescription),
                  onTap: () {
                    // Show a popup component to edit the name and description of the item
                    showDialog(
                      context: context,
                      builder: (context) {
                        String newName = itemName;
                        String newDescription = itemDescription;

                        return AlertDialog(
                          title: Text('Edit Item'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextFormField(
                                initialValue: itemName,
                                onChanged: (value) {
                                  newName = value;
                                },
                              ),
                              TextFormField(
                                initialValue: itemDescription,
                                onChanged: (value) {
                                  newDescription = value;
                                },
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                // Save the updated name and description
                                setState(() {
                                  // listItems[itemId]!['name'] = newName;
                                  // listItems[itemId]!['description'] = newDescription;
                                });
                                Navigator.pop(context);
                              },
                              child: Text('Save'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              },
            ),

            // Display the list of items and allow updating their names and descriptions
            // You can use ListView.builder or any other widget to display the items
          ],
        ),
      ),
    );
  }
}

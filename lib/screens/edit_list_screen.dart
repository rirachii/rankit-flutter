import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../ListData.dart';
import '../box.dart' as globalBox;

class EditListScreen extends StatefulWidget {
  final String listId;

  EditListScreen({required this.listId});

  @override
  _EditListScreenState createState() => _EditListScreenState();
}

class _EditListScreenState extends State<EditListScreen> {
  final _formKey = GlobalKey<FormState>();
  late String listName;
  late String listDescription;
  late List<Map<String, String>> _itemFields;

  late TextEditingController _listNameController =
      TextEditingController(text: listName);
  late TextEditingController _descriptionController =
      TextEditingController(text: listDescription);
  final _itemNameController = TextEditingController();
  final _itemDescriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final listObject = globalBox.listBox.get(widget.listId);
    listName = listObject.listName;
    listDescription = listObject.listDescription;
    _itemFields = listObject.items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit list'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: _listNameController,
              decoration: InputDecoration(hintText: 'List Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(hintText: 'List Description'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
            ),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    TextEditingController itemNameController =
                        TextEditingController();
                    TextEditingController itemDescriptionController =
                        TextEditingController();

                    return AlertDialog(
                      title: Text('Add Item'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            controller: itemNameController,
                            decoration: InputDecoration(hintText: 'Item Name'),
                          ),
                          TextFormField(
                            controller: itemDescriptionController,
                            decoration:
                                InputDecoration(hintText: 'Item Description'),
                          ),
                        ],
                      ),
                      actions: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _itemFields.add({
                                'itemId': 'item-${Uuid().v1()}',
                                'itemName': itemNameController.text,
                                'itemDescription':
                                    itemDescriptionController.text,
                              });
                            });
                            Navigator.of(context).pop();
                          },
                          child: Text('Add'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Cancel'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text('Add Item'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _itemFields.length,
                itemBuilder: (context, index) {
                  var item = _itemFields[index];
                  String name = item["itemName"] ?? '';
                  String description = item["itemDescription"] ?? '';

                  return GestureDetector(
                    onTap: () {
                      // Handle item click here
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          TextEditingController itemNameController =
                              TextEditingController(text: name);
                          TextEditingController itemDescriptionController =
                              TextEditingController(text: description);

                          return AlertDialog(
                            title: Text('Edit Item'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextFormField(
                                  controller: itemNameController,
                                  decoration:
                                      InputDecoration(hintText: 'Item Name'),
                                ),
                                TextFormField(
                                  controller: itemDescriptionController,
                                  decoration: InputDecoration(
                                      hintText: 'Item Description'),
                                ),
                              ],
                            ),
                            actions: [
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    var item = _itemFields[index];
                                    item['itemName'] = itemNameController.text;
                                    item['itemDescription'] =
                                        itemDescriptionController.text;
                                  });
                                  Navigator.of(context).pop();
                                },
                                child: Text('Update'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _itemFields.removeAt(index);
                                  });
                                  Navigator.of(context).pop();
                                },
                                child: Text('Delete'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Cancel'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: ListTile(
                      title: Text(name),
                      subtitle: Text(description),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (_itemFields.length == 0) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Error'),
                        content: Text('Must have 1 item.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  setState(() {
                    ListData listObject = globalBox.listBox.get(widget.listId);
                    listObject.listName = _listNameController.text;
                    listObject.listDescription = _descriptionController.text;
                    listObject.items = _itemFields;
                    globalBox.listBox.put(widget.listId, listObject);
                  });
                  Navigator.of(context).pop();
                }
              },
              child: Text('Update'),
            ),
            ElevatedButton(
              onPressed: () {
                globalBox.listBox.delete(widget.listId);
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }
}

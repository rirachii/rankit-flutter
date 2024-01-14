import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../ListData.dart';
import '../box.dart' as globalBox;

class CreateListScreen extends StatefulWidget {
  @override
  _CreateListScreenState createState() => _CreateListScreenState();
}

class _CreateListScreenState extends State<CreateListScreen> {
  final _formKey = GlobalKey<FormState>();
  final _listNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _itemNameController = TextEditingController();
  final _itemDescriptionController = TextEditingController();
  List<Map<String, String>> _itemFields = [];

  @override
  void initState() {
    super.initState();
  }

  void addList() {
    if (_formKey.currentState!.validate()) {
      final uuid = Uuid();
      final listId = Uuid().v1();
      final listName = _listNameController.text;
      final listDescription = _descriptionController.text;

      final newList = ListData(
        listId: listId,
        listName: listName,
        listDescription: listDescription,
        items: _itemFields,
      );

      globalBox.listBox.put(listId, newList);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create a new list'),
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
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a item name';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: itemDescriptionController,
                            decoration:
                                InputDecoration(hintText: 'Item Description'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a item description';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                      actions: [
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                _itemFields.add({
                                  'itemId': 'item-${Uuid().v1()}',
                                  'itemName': itemNameController.text,
                                  'itemDescription':
                                      itemDescriptionController.text,
                                });
                              });
                            }
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
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter a item name';
                                    }
                                    return null;
                                  },
                                ),
                                TextFormField(
                                  controller: itemDescriptionController,
                                  decoration: InputDecoration(
                                      hintText: 'Item Description'),
                                  validator: (value) {
                                    if (value == null ||
                                        value.isEmpty ||
                                        value.length > 0) {
                                      return 'Please enter a item description';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                            actions: [
                              ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    setState(() {
                                    var item = _itemFields[index];
                                    item['itemName'] = itemNameController.text;
                                    item['itemDescription'] =
                                        itemDescriptionController.text;
                                  });
                                  } else {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text('Validation Error'),
                                          content: Text('Please enter some text'),
                                          actions: <Widget>[
                                            TextButton(
                                              child: Text('OK'),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                  
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
                        content: Text('Please add an item.'),
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
                  addList();
                }
              },
              child: Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}

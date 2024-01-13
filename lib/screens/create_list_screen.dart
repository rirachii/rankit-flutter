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
  // late Box<ListData> listBox;
  final _formKey = GlobalKey<FormState>();
  final _listNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _itemNameController = TextEditingController();
  final _itemDescriptionController = TextEditingController();
  Map<String, Map<String, String>> _items = {};
  List<Map<String, String>> _itemFields = [];

  @override
  void initState() {
    super.initState();
    // listBox = Hive.box<ListData>('lists');
  }

  void addList() {
    if (_formKey.currentState!.validate()) {
      final uuid = Uuid();
      final listId = Uuid().v1();
      final listName = _listNameController.text;
      final listDescription = _descriptionController.text;
      // final items = {
      //   for (var field in _itemFields)
      //     field['name'].text: {'description': field['description'].text}
      // };

      final newList = ListData(
        listId: listId,
        listName: listName,
        listDescription: listDescription,
        items: _itemFields,
      );

      globalBox.listBox.put(listId, newList);
      // _listNameController.clear();
      // _descriptionController.clear();
      // _itemNameController.clear();
      // _itemDescriptionController.clear();
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
              decoration: InputDecoration(hintText: 'Description'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
            ),
            // TextFormField(
            //   controller: _itemsController,
            //   decoration: InputDecoration(hintText: 'Items (comma separated)'),
            //   validator: (value) {
            //     if (value == null || value.isEmpty) {
            //       return 'Please enter at least one item';
            //     }
            //     return null;
            //   },
            // ),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    TextEditingController itemNameController = TextEditingController();
                    TextEditingController itemDescriptionController = TextEditingController();

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
                            decoration: InputDecoration(hintText: 'Item Description'),
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
                                'itemDescription': itemDescriptionController.text,
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
                          TextEditingController itemNameController = TextEditingController(text: name);
                          TextEditingController itemDescriptionController = TextEditingController(text: description);

                          return AlertDialog(
                            title: Text('Edit Item'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextFormField(
                                  controller: itemNameController,
                                  decoration: InputDecoration(hintText: 'Item Name'),
                                ),
                                TextFormField(
                                  controller: itemDescriptionController,
                                  decoration: InputDecoration(hintText: 'Item Description'),
                                ),
                              ],
                            ),
                            actions: [
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    var item = _itemFields[index];
                                    item['itemName'] = itemNameController.text;
                                    item['itemDescription'] = itemDescriptionController.text;
                                  });
                                  Navigator.of(context).pop();
                                },
                                child: Text('Save'),
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
              onPressed: addList,
              child: Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}
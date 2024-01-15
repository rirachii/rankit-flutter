import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../ListData.dart';
import '../box.dart' as globalBox;

class EditListScreen extends StatefulWidget {
  final String listId;

  const EditListScreen({super.key, required this.listId});

  @override
  _EditListScreenState createState() => _EditListScreenState();
}

class _EditListScreenState extends State<EditListScreen> {
  final _formKey = GlobalKey<FormState>();
  late String listName;
  late String listDescription;
  late List<Map<String, String>> itemFields;

  late final TextEditingController _listNameController =
      TextEditingController(text: listName);
  late final TextEditingController _descriptionController =
      TextEditingController(text: listDescription);
  final _itemNameController = TextEditingController();
  final _itemDescriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final listObject = globalBox.listBox.get(widget.listId);
    listName = listObject.listName;
    listDescription = listObject.listDescription;
    itemFields = listObject.items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit list'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: _listNameController,
              decoration: const InputDecoration(hintText: 'List Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(hintText: 'List Description'),
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
                      title: const Text('Add Item'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            controller: itemNameController,
                            decoration: const InputDecoration(hintText: 'Item Name'),
                          ),
                          TextFormField(
                            controller: itemDescriptionController,
                            decoration:
                                const InputDecoration(hintText: 'Item Description'),
                          ),
                        ],
                      ),
                      actions: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              itemFields.add({
                                'itemId': 'item-${const Uuid().v1()}',
                                'itemName': itemNameController.text,
                                'itemDescription':
                                    itemDescriptionController.text,
                              });
                            });
                            Navigator.of(context).pop();
                          },
                          child: const Text('Add'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancel'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text('Add Item'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: itemFields.length,
                itemBuilder: (context, index) {
                  var item = itemFields[index];
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
                            title: const Text('Edit Item'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextFormField(
                                  controller: itemNameController,
                                  decoration:
                                      const InputDecoration(hintText: 'Item Name'),
                                ),
                                TextFormField(
                                  controller: itemDescriptionController,
                                  decoration: const InputDecoration(
                                      hintText: 'Item Description'),
                                ),
                              ],
                            ),
                            actions: [
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    var item = itemFields[index];
                                    item['itemName'] = itemNameController.text;
                                    item['itemDescription'] =
                                        itemDescriptionController.text;
                                  });
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Update'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    itemFields.removeAt(index);
                                  });
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Delete'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Cancel'),
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
                if (itemFields.isEmpty) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Error'),
                        content: const Text('Must have 1 item.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('OK'),
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
                    listObject.items = itemFields;
                    globalBox.listBox.put(widget.listId, listObject);
                  });
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Update'),
            ),
            ElevatedButton(
              onPressed: () {
                globalBox.listBox.delete(widget.listId);
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }
}

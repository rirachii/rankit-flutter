import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../objects/list_data.dart';
import '../objects/item.dart';
import '../service/firestore_service.dart';

class EditListScreen extends StatefulWidget {
  final ListData listData;

  const EditListScreen({super.key, required this.listData});
  
  @override
  _EditListScreenState createState() => _EditListScreenState();
  
}

class _EditListScreenState extends State<EditListScreen> {
  final _formKey = GlobalKey<FormState>();
  final String collection = "Public Lists";
  late String listId = widget.listData.listId;
  late String listName= widget.listData.listName;
  late String listDescription = widget.listData.listDescription;
  late List<Item> itemFields = widget.listData.items;

  late final TextEditingController _listNameController =
      TextEditingController(text: listName);
  late final TextEditingController _descriptionController =
      TextEditingController(text: listDescription);
  // final _itemNameController = TextEditingController();
  // final _itemDescriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }


  void updateList() async {
    ListData listObject = widget.listData;
    listObject.listName = _listNameController.text;
    listObject.listDescription = _descriptionController.text;
    listObject.items = itemFields;
    FirestoreService.update(collection, listId, listObject.toMap());
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
                              Item item = Item(id: 'item-${const Uuid().v1()}', name: itemNameController.text, description: itemDescriptionController.text, imageUrl: 'imageFile?.path');
                              itemFields.add(item);
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
                  Item item = itemFields[index];
                  String name = item.getName;
                  String description = item.getDescription;

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
                                  decoration: const InputDecoration(
                                      hintText: 'Item Name'),
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
                                    Item item = itemFields[index];
                                    item.setName = itemNameController.text;
                                    item.setDescription = itemDescriptionController.text;
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
                  updateList();
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Update'),
            ),
            ElevatedButton(
              onPressed: () {
                FirestoreService.delete(collection, listId);
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

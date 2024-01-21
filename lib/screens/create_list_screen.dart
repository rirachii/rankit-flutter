import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import '../objects/list_data.dart';
import '../objects/item.dart';
import '../objects/box.dart' as global_box;

class CreateListScreen extends StatefulWidget {
  const CreateListScreen({super.key});

  @override
  _CreateListScreenState createState() => _CreateListScreenState();
}

class _CreateListScreenState extends State<CreateListScreen> {
  final _formKey = GlobalKey<FormState>();
  final _listNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _itemNameController = TextEditingController();
  final _itemDescriptionController = TextEditingController();
  final List<Item> _itemFields = [];
  late User user;
  File? _imageFile;
  String _listImgUrl = '';
  String visibility = 'Private';
  final List<String> _tags = [];

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser!;
  }

  void uploadPublicImage(file) async {
    final ref = FirebaseStorage.instance
      .ref()
      .child('Public Lists Images')
      .child('${_listNameController.text}.png');
    await ref.putFile(file);
    _listImgUrl = await ref.getDownloadURL();
  }

  void addList() {
    if (_formKey.currentState!.validate()) {
      final listId = const Uuid().v1();
      final listName = _listNameController.text;
      final listDescription = _descriptionController.text;

      uploadPublicImage(_imageFile);

      final newList = ListData(
        listId: listId,
        listName: listName,
        listDescription: listDescription,
        items: _itemFields,
        listImgUrl: _listImgUrl,
        visibility: 'Private',
        dateCreated: DateTime.now(),
        lastUpdated: DateTime.now(),
        updateNote: '',
        likes: 1,
        completed: 0,
        creatorId: user.uid,
        creatorName: user.displayName,
        creatorPfp: user.photoURL,
        tags: [],
      );

      global_box.listBox.put(listId, newList);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create a new list'),
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
            DropdownButton<String>(
              value: visibility,
              icon: const Icon(Icons.arrow_downward),
              iconSize: 24,
              elevation: 16,
              style: const TextStyle(color: Colors.deepPurple),
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              onChanged: (String? newValue) {
                setState(() {
                  visibility = newValue!;
                });
              },
              items: <String>['Private', 'Public', 'Unlisted']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            ElevatedButton(
              child: const Text('Pick Image'),
              onPressed: () async {
                final picker = ImagePicker();
                final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                if (pickedFile != null) {
                  setState(() {
                    _imageFile = File(pickedFile.path);
                  });
                }
              },
            ),
            _imageFile != null ? SizedBox(
              width: 200, // Replace with your desired width
              height: 200, // Replace with your desired height
              child: Image.file(_imageFile!),
            ) : Container(),
            TextField(
              onSubmitted: (value) {
                if (_tags.length < 5) {
                  setState(() {
                    _tags.add(value);
                    value = '';
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('You can only add up to 5 tags')),
                  );
                }
              },
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: _tags.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_tags[index]),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        _tags.removeAt(index);
                      });
                    },
                  ),
                );
              },
            ),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    File? imageFile;
                    return AlertDialog(
                      title: const Text('Add Item'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            controller: _itemNameController,
                            decoration:
                                const InputDecoration(hintText: 'Item Name'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a item name';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: _itemDescriptionController,
                            decoration: const InputDecoration(
                                hintText: 'Item Description'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a item description';
                              }
                              return null;
                            },
                          ),
                          ElevatedButton(
                            child: const Text('Pick Image'),
                            onPressed: () async {
                              final picker = ImagePicker();
                              final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                              if (pickedFile != null) {
                                setState(() {
                                  imageFile = File(pickedFile.path);
                                });
                              }
                            },
                          ),
                          imageFile != null ? SizedBox(
                            width: 200, // Replace with your desired width
                            height: 200, // Replace with your desired height
                            child: Image.file(imageFile!),
                          ) : Container(),
                        ],
                      ),
                      actions: [
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                Item item = Item(id: 'item-${const Uuid().v1()}', name: _itemNameController.text, description: _itemDescriptionController.text, imageUrl: 'imageFile?.path');
                                _itemFields.add(item);
                              });
                            }
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
                itemCount: _itemFields.length,
                itemBuilder: (context, index) {
                  var item = _itemFields[index];
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
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter a item name';
                                    }
                                    return null;
                                  },
                                ),
                                TextFormField(
                                  controller: itemDescriptionController,
                                  decoration: const InputDecoration(
                                      hintText: 'Item Description'),
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
                                      Item item = _itemFields[index];
                                      item.setName= itemNameController.text;
                                      item.setDescription = itemDescriptionController.text;
                                    });
                                  } else {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text('Validation Error'),
                                          content: const Text(
                                              'Please enter some text'),
                                          actions: <Widget>[
                                            TextButton(
                                              child: const Text('OK'),
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
                                child: const Text('Update'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _itemFields.removeAt(index);
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
                if (_itemFields.isEmpty) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Error'),
                        content: const Text('Please add an item.'),
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
                  addList();
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}

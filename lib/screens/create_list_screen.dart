import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../ListData.dart';

class CreateListScreen extends StatefulWidget {
  @override
  _CreateListScreenState createState() => _CreateListScreenState();
}

class _CreateListScreenState extends State<CreateListScreen> {
  late Box<ListData> listBox;
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();
  final _descriptionController = TextEditingController();
  final _itemsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // listBox = Hive.box<ListData>('lists');
  }

  void addList() async {
    if (_formKey.currentState!.validate()) {
      var box = await Hive.openBox<ListData>('lists');

      var uuid = Uuid();
      var newListData = ListData(
        listId: uuid.v1(),
        listName: _listNameController.text,
        description: _descriptionController.text,
        items: _itemsController.text
            .split(',')
            .map((item) => Item(name: item))
            .toList(),
        // Set other fields...
      );

      await box.add(listData);
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
              controller: _controller,
              decoration: InputDecoration(hintText: 'List title'),
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
            TextFormField(
              controller: _itemsController,
              decoration: InputDecoration(hintText: 'Items (comma separated)'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter at least one item';
                }
                return null;
              },
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

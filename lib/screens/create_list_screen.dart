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

  @override
  void initState() {
    super.initState();
    listBox = Hive.box<ListData>('lists');
  }

  void addList() {
    if (_formKey.currentState!.validate()) {
      var listData = ListData()..title = _controller.text;
      listBox.add(listData);
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
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/models/TodoItem.dart';
import 'package:todo_app/uitils/DatabaseClient.dart';
import 'package:todo_app/uitils/dateFormater.dart';

class TodoScr extends StatefulWidget {
  @override
  _TodoScrState createState() => _TodoScrState();
}

class _TodoScrState extends State<TodoScr> {
  TextEditingController _textFieldController = new TextEditingController();
  var db = new DatabaseHelper();
  List<TodoItem> _items = <TodoItem>[];

  @override
  void initState() {
    super.initState();
    _readTodoList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black26,
      body: Column(
        children: <Widget>[
          Flexible(
            child: ListView.builder(
                itemCount: _items.length,
                itemBuilder: (_, int postion) {
                  return Card(
                    color: Colors.white,
                    child: ListTile(
                      title: _items[postion],
                      onLongPress: () => _editItem(_items[postion], postion),
                      trailing: Listener(
                        key: Key(_items[postion].itemName),
                        child: Icon(
                          Icons.remove_circle,
                          color: Colors.red,
                        ),
                        onPointerDown: (pointerEvent) =>_removeItem(_items[postion].id, postion),
                      ),
                    ),
                  );
                }),
          ),
          Divider(
            height: 1.5,
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showFormDialog,
        child: ListTile(
          title: Icon(Icons.add),
        ),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _showFormDialog() {
    var alert = new AlertDialog(
      title: Text("Add Item"),
      content: new Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _textFieldController,
              autofocus: true,
              decoration: InputDecoration(
                  labelText: "Item",
                  hintText: "e.g Car",
                  icon: Icon(Icons.add_alert)),
            ),
          )
        ],
      ),
      actions: <Widget>[
        FlatButton(
            onPressed: () {
              _handelSubmit(_textFieldController.text);
              _textFieldController.clear();
              Navigator.pop(context);
            },
            child: Text("Save")),
        FlatButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancel"),
        )
      ],
    );
    showDialog(
        context: context,
        builder: (_) {
          return alert;
        });
  }

  _readTodoList() async {
    List items = await db.getAllItems();
    items.forEach((item) {
      setState(() {
        _items.add(TodoItem.map(item));
      });
    });
  }

  _removeItem(int id, int postion) async {
    await db.deleteItem(id);
    setState(() {
      _items.removeAt(postion);
    });
  }

  void _handelSubmit(String text) async {
    var todoItem = new TodoItem(text, dateFormat());
    int savedItemId = await db.saveTodoItem(todoItem);
    TodoItem savedItem = await db.getTodoItem(savedItemId);
    setState(() {
      _items.add(savedItem);
    });
  }

  _editItem(TodoItem item, int postion) {
    var alert = new AlertDialog(
      title: Text("Edit Item"),
      content: new Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _textFieldController,
              autofocus: true,
              decoration: InputDecoration(
                  labelText: "Item",
                  hintText: "e.g Car",
                  icon: Icon(Icons.add_alert)),
            ),
          )
        ],
      ),
      actions: <Widget>[
        FlatButton(
            onPressed: () async {
              TodoItem editedItem = TodoItem.fromMap({
                "itemName": _textFieldController.text,
                "dateCreated": dateFormat(),
                "id": item.id
              });
              _handelEdit(postion, editedItem);
              await db.updateItem(editedItem);
              _items.clear();
              setState(() {
                _readTodoList();
              });
              _textFieldController.clear();
              Navigator.pop(context);
            },
            child: Text("Save")),
        FlatButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancel"),
        )
      ],
    );
    showDialog(
        context: context,
        builder: (_) {
          return alert;
        });
  }

  void _handelEdit(int postion, TodoItem editedItem) {
    setState(() {
      _items.removeWhere((element) => _items[postion].itemName == editedItem.itemName);
    });
  }
}

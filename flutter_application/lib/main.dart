import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_application/hero_dialog_route.dart';
import 'package:flutter_application/widgets/add_todo_popup_card.dart';
import 'package:flutter_application/models/TodoItem.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      home: const MyHomePage(title: 'Cosas por hacer :'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<ToDoItem> items = [
    ToDoItem('Hacer tarea y Proyetco Integrador', order: 0),
    ToDoItem('Comprar la despensa de la casa', order: 1),
    ToDoItem('Ir a mi cita con el dentista', order: 2),
  ];

  updateList(e) {
    setState(() {
      List<ToDoItem> checkeds =
          this.items.where((element) => element.checked).toList();
      checkeds.sort((a, b) => a.order - b.order);

      List<ToDoItem> uncheckeds =
          this.items.where((element) => !element.checked).toList();
      uncheckeds.sort((a, b) => a.order - b.order);

      this.items.clear();
      this.items.addAll([...uncheckeds, ...checkeds]);
    });
  }

  final textCtrl = TextEditingController();

  openPopUpCard(void Function(String) onSave) {
    Navigator.of(context).push(HeroDialogRoute(
      builder: (context) {
        return AddTodoPopupCard(
          textCtrl: textCtrl,
          onSave: (text) {
            onSave(text);
            updateList(e);
            textCtrl.text = '';
            Navigator.of(context).pop();
          },
        );
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    items.isNotEmpty;
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(widget.title),
        toolbarHeight: 180,
      ),
      body: ListView(
        children: [
          ...this.items.map((e) => ListTile(
                leading: Checkbox(
                  checkColor: Colors.transparent,
                  activeColor: Colors.grey.shade400,
                  onChanged: (e) {},
                  value: e.checked,
                ),
                title: Opacity(
                  opacity: e.checked ? 0.5 : 1,
                  child: Text(
                    e.text,
                    style: TextStyle(
                      color: e.checked ? Colors.grey.shade500 : Colors.black,
                      decoration: e.checked ? TextDecoration.lineThrough : null,
                    ),
                  ),
                ),
                trailing: PopupMenuButton<String>(
                  onSelected: (t) {
                    switch (t) {
                      case 'edit':
                        this.textCtrl.text = e.text;
                        openPopUpCard((text) => this
                            .items
                            .firstWhere((element) => element.order == e.order)
                            .text = text);
                        break;
                      case 'delete':
                        this
                            .items
                            .removeWhere((element) => element.order == e.order);
                        updateList(e);
                        break;
                    }
                  },
                  icon: Icon(Icons.more_vert),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    side: BorderSide(color: Color(0x99FFFFFF), width: 2),
                  ),
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem<String>(
                        height: 12,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.edit, color: Colors.white),
                            Text(
                              'Edit',
                              textAlign: TextAlign.right,
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        value: 'edit',
                      ),
                      PopupMenuDivider(
                        height: 9,
                      ),
                      PopupMenuItem<String>(
                        height: 12,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.delete, color: Colors.red),
                            Text(
                              'Edit',
                              textAlign: TextAlign.right,
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                        value: 'delete',
                      ),
                    ];
                  },
                  color: Colors.grey.shade700,
                ),
                onTap: () {
                  e.checked = !e.checked;
                  updateList(e);
                },
              ))
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 15.0),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(HeroDialogRoute(
              builder: (context) {
                return AddTodoPopupCard(
                    textCtrl: textCtrl,
                    onSave: (text) {
                      setState(() {
                        items.add(ToDoItem(text,
                            order: items
                                    .reduce((value, element) =>
                                        element.order > value.order
                                            ? element
                                            : value)
                                    .order +
                                1));
                      });
                      updateList(e);
                      textCtrl.text = '';
                      Navigator.of(context).pop();
                    });
              },
            ));
          },
          child: Hero(
            tag: 'add-todo-hero',
            child: Material(
              color: Colors.grey.shade800,
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32),
                  side: const BorderSide(
                    width: 2,
                    color: Color(0x99FFFFFF),
                  )),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: const Icon(
                  Icons.add_rounded,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

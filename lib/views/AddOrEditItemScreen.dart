import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ListViewDemo/models/Item.dart';
import 'package:ListViewDemo/models/Items.dart';

class AddOrEditItemScreen extends StatefulWidget {
  final Items items;
  int _index = -1;
  AddOrEditItemScreen({this.items});
  AddOrEditItemScreen.update(this.items, this._index);

  @override
  _AddOrEditItemScreenState createState() => _AddOrEditItemScreenState();
}

class _AddOrEditItemScreenState extends State<AddOrEditItemScreen> {
  bool _enableSave = false;
  TextEditingController _inputTitleController = new TextEditingController();
  TextEditingController _inputDescriptionController = new TextEditingController();

    //Old data
  String oldTitle = '';
  String oldDescription = '';

  void _updateSaveStatus(bool status) {
    setState(() {
      _enableSave = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget._index < 0 ? 'Add Item Screen' : 'Update Item Screen'),
        actions: [
          IconButton(
              icon: Icon(
                Icons.done,
                color: _enableSave ? Colors.red : Colors.grey,
              ),
              onPressed: _enableSave
                  ? () {
                      if (widget._index < 0) {
                        widget.items.addBook(Item(_inputTitleController.text,
                            _inputDescriptionController.text));
                      } else {
                        widget.items.updateBook(
                            Item(_inputTitleController.text,
                                _inputDescriptionController.text),
                            widget._index);
                      }
                      Navigator.pop(context);
                    }
                  : null)
        ],
      ),
      body: SafeArea(
          child: Container(
        child: Column(
          children: [
            _inputForm(
                context,
                widget._index < 0
                    ? "Input title"
                    : widget.items.getItem(widget._index).title,
                _inputTitleController),
            _inputForm(
                context,
                widget._index < 0
                    ? "Input description"
                    : widget.items.getItem(widget._index).description,
                _inputDescriptionController),
          ],
        ),
      )),
    );
  }

  @override
  void initState() {
    _inputTitleController.addListener(() {
      checkSaveStatus();
    });
    _inputDescriptionController.addListener(() {
      checkSaveStatus();
    });
    if (widget._index >= 0) {
      _inputTitleController.text = widget.items.getItem(widget._index).title;
      oldTitle = widget.items.getItem(widget._index).title;
      _inputDescriptionController.text = widget.items.getItem(widget._index).description;
      oldDescription = widget.items.getItem(widget._index).description;
      _enableSave = false;
    }

    super.initState();
  }

  void checkSaveStatus() {
    if ((_inputTitleController.text.isEmpty ||
            _inputDescriptionController.text.isEmpty) &&
        _enableSave) {
      _updateSaveStatus(false);
    } else if (_inputTitleController.text.isNotEmpty &&
        _inputDescriptionController.text.isNotEmpty &&
        !_enableSave) {
          if (oldTitle.isNotEmpty && oldDescription.isNotEmpty) {
            if (oldTitle == _inputTitleController.text && oldDescription == _inputDescriptionController.text) {
              _updateSaveStatus(false);
            } else {
              _updateSaveStatus(true);
            }
          } else {
            _updateSaveStatus(true);
          }
    } else {
      if (oldTitle.isNotEmpty && oldDescription.isNotEmpty) {
        if (oldTitle == _inputTitleController.text && oldDescription == _inputDescriptionController.text) {
              _updateSaveStatus(false);
        }
      }
    }
  }

  @override
  void dispose() {
    _inputTitleController.dispose();
    _inputDescriptionController.dispose();
    super.dispose();
  }
}

Widget _inputForm(BuildContext context, String hint,
    TextEditingController textEditingController) {
  return Container(
    margin: EdgeInsets.all(10),
    child: TextField(
      controller: textEditingController,
      textAlign: TextAlign.left,
      decoration: InputDecoration(
          filled: true,
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          )),
    ),
  );
}

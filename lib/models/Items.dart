import 'package:flutter/material.dart';
import 'package:ListViewDemo/models/Item.dart';

class Items extends ChangeNotifier {
  final List<Item> _data = <Item>[];

  List<Item> get getData => _data;

  Item getItem(int index) => _data[index];

  int get getTotalCount => _data.length;

  void addBook(Item book) {
    _data.add(book);
    notifyListeners();
  }

  void updateBook(Item item, int index) {
    _data[index].title = item.title;
    _data[index].description = item.description;
    notifyListeners();
  }
}
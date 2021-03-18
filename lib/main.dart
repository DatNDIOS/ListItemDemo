import 'package:ListItemsDemo/models/Items.dart';
import 'package:ListItemsDemo/views/AddOrEditItemScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:ListItemsDemo/models/Item.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MaterialApp(
    title: 'Passing Data',
    home: ListItemsScreen(
      items: List.generate(
        5,
        (i) => Item(
          'Todo $i',
          'A description of what needs to be done for Todo $i',
        ),
      ),
    ),
  ));
}

class ListItemsScreen extends StatelessWidget {
  final List<Item> items;

  ListItemsScreen({Key key, @required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Items>(
      create: (context) => new Items(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('ListItems'),
          actions: [
            Consumer<Items>(builder: (context, mymodel, child) {
              return IconButton(
                  icon: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => new AddOrEditItemScreen(
                                items: mymodel,
                              ))));
            }),
          ],
        ),
        body: SafeArea(child: Container(
          child: Consumer<Items>(builder: (context, mymodel, child) {
            return _listItemView(context, mymodel);
          }),
        ),
      ),
    )
    );
  }
}

Widget _listItemView(BuildContext context, Items items) {
  return ListView.builder(
    itemCount: items.getTotalCount,
    itemBuilder: (context, index) {
      return ListTile(
            title: Text(items.getData[index].title),
            subtitle: Text(items.getData[index].description),
            // When a user taps the ListTile, navigate to the DetailScreen.
            // Notice that you're not only creating a DetailScreen, you're
            // also passing the current todo through to it.
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddOrEditItemScreen.update(items, index),
                ),
              );
            },
          );
    },
  );
}
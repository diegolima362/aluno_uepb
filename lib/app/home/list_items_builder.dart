import 'package:erdm/app/home/empty_content.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

typedef ItemWidgetBuilder<T> = Widget Function(BuildContext context, T item);

class ListItemsBuilder<T> extends StatelessWidget {
  final Box box;
  final String boxName;
  final ItemWidgetBuilder<T> itemBuilder;
  final Function filter;

  const ListItemsBuilder({
    Key key,
    @required this.box,
    @required this.boxName,
    @required this.itemBuilder,
    this.filter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (box.isNotEmpty) {
      final List<T> items = box.get(boxName);
      if (items.isNotEmpty) {
        return filter != null ? _buildList(filter(items)) : _buildList(items);
      } else {
        return EmptyContent(
          title: 'Algo deu errado',
          message: 'Os items não puderam ser carregados agora',
        );
      }
    }
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 10.0),
          Text('Carregando ...'),
        ],
      ),
    );
  }

  Widget _buildList(List<T> items) {
    if (items == null || items.isEmpty)
      return EmptyContent(
        title: 'Nada por aqui',
        message: 'Você não tem aulas hoje!',
      );

    return ListView.separated(
      itemCount: items.length + 2,
      separatorBuilder: (context, index) => Divider(height: 0.5),
      itemBuilder: (context, index) {
        if (index == 0 || index == items.length + 1) {
          return Container();
        }
        return itemBuilder(context, items[index - 1]);
      },
    );
  }
}

import 'package:cau3pb/common_widgets/empty_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef ItemWidgetBuilder<T> = Widget Function(BuildContext context, T item);

class ListItemsBuilder<T> extends StatelessWidget {
  final AsyncSnapshot<List<T>> snapshot;
  final ItemWidgetBuilder<T> itemBuilder;
  final Function filter;

  const ListItemsBuilder({
    Key key,
    @required this.snapshot,
    @required this.itemBuilder,
    this.filter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (snapshot.hasData) {
      final List<T> items = snapshot.data;
      if (items.isNotEmpty) {
        return filter != null ? _buildList(filter(items)) : _buildList(items);
      } else {
        return EmptyContent(
          title: 'Nada por aqui',
          message: 'Você não tem aulas hoje',
        );
      }
    } else if (snapshot.hasError) {
      return EmptyContent(
        title: 'Algo deu errado',
        message: snapshot.error.runtimeType == PlatformException
            ? '${(snapshot.error as PlatformException).message}'
            : snapshot.error.toString(),
      );
    }
    return Center(child: CircularProgressIndicator());
  }

  Widget _buildList(List<T> items) {
    if (items == null || items.isEmpty) {
      return EmptyContent(
        title: 'Nada por aqui',
        message: 'Você não tem aulas hoje!',
      );
    }

    return ListView.builder(
      itemCount: items.length + 2,
      itemBuilder: (context, index) {
        if (index == 0 || index == items.length + 1) {
          return Container();
        }
        return itemBuilder(context, items[index - 1]);
      },
    );
  }
}

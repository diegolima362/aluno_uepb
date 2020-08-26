import 'package:aluno_uepb/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef ItemWidgetBuilder<T> = Widget Function(BuildContext context, T item);

class ListItemsBuilder<T> extends StatelessWidget {
  final AsyncSnapshot<List<T>> snapshot;
  final ItemWidgetBuilder<T> itemBuilder;
  final String emptyMessage;
  final Function filter;

  const ListItemsBuilder({
    Key key,
    @required this.snapshot,
    @required this.itemBuilder,
    this.filter,
    this.emptyMessage,
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
          message: emptyMessage ?? 'Você não tem aulas hoje',
        );
      }
    } else if (snapshot.hasError) {
      print(snapshot.error.toString());
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
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 8.0),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return itemBuilder(context, items[index]);
      },
    );
  }
}

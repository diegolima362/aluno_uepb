import 'package:aluno_uepb/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef ItemWidgetBuilder<T> = Widget Function(BuildContext context, T item);

class ListItemsBuilder<T> extends StatelessWidget {
  final AsyncSnapshot<List<T>> snapshot;
  final ItemWidgetBuilder<T> itemBuilder;
  final String emptyTitle;
  final String emptyMessage;
  final String errorMessage;
  final Function filter;
  final Widget emptyWidget;

  ListItemsBuilder({
    Key key,
    @required this.snapshot,
    @required this.itemBuilder,
    this.filter,
    this.emptyMessage,
    this.emptyTitle,
    this.emptyWidget,
    this.errorMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (snapshot.hasData) {
      final List<T> items = snapshot.data;

      if (items.isNotEmpty) {
        return filter != null ? _buildList(filter(items)) : _buildList(items);
      } else {
        return emptyWidget ??
            EmptyContent(title: emptyTitle, message: emptyMessage);
      }
    } else if (snapshot.hasError) {
      print(snapshot.error.toString());
      return EmptyContent(
        title: errorMessage,
        message: snapshot.error.runtimeType == PlatformException
            ? '${(snapshot.error as PlatformException).message}'
            : snapshot.error.toString(),
      );
    }
    return Center(child: CircularProgressIndicator());
  }

  Widget _buildList(List<T> items) {
    if (items == null || items.isEmpty) {
      return EmptyContent();
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 8.0),
      itemCount: items.length,
      itemBuilder: (context, index) => itemBuilder(context, items[index]),
    );
  }
}

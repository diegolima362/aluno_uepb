import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import 'empty_content.dart';

typedef ItemWidgetBuilder<T> = Widget Function(BuildContext context, T item);

class ListItemsBuilder<T> extends StatelessWidget {
  final AsyncSnapshot<List<T>> snapshot;
  final ItemWidgetBuilder<T> itemBuilder;
  final bool horizontal;
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
    this.horizontal = false,
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
        return filter != null
            ? _buildList(filter(items), context)
            : _buildList(items, context);
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

  Widget _buildList(List<T> items, BuildContext context) {
    if (items == null || items.isEmpty) {
      return EmptyContent(message: emptyMessage, title: emptyTitle);
    }

    final ratio = MediaQuery.of(context).size.aspectRatio;

    if (ratio > 1 && !horizontal) {
      return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: MediaQuery.of(context).size.width /
              (MediaQuery.of(context).size.height / 2),
        ),
        itemCount: items.length,
        itemBuilder: (context, index) => itemBuilder(context, items[index]),
      );
    } else {
      return ListView.builder(
        scrollDirection: horizontal ? Axis.horizontal : Axis.vertical,
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 8.0),
        itemCount: items.length,
        itemBuilder: (context, index) => itemBuilder(context, items[index]),
      );
    }
  }
}

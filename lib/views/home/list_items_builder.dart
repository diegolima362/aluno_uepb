import 'package:aluno_uepb/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';

typedef ItemWidgetBuilder<T> = Widget Function(BuildContext context, T item);

class ListItemsBuilder<T> extends StatelessWidget {
  final AsyncSnapshot<List<T>> snapshot;
  final ItemWidgetBuilder<T> itemBuilder;
  final String emptyTitle;
  final String emptyMessage;
  final Function filter;
  final Widget emptyWidget;

  final String adUnitID;
  final _nativeAdController = NativeAdmobController();

  ListItemsBuilder({
    Key key,
    @required this.snapshot,
    @required this.itemBuilder,
    this.filter,
    this.emptyMessage,
    this.emptyTitle,
    this.emptyWidget,
    this.adUnitID,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (snapshot.hasData) {
      final List<T> items = snapshot.data;

      if (items.isNotEmpty) {
        return filter != null ? _buildList(filter(items)) : _buildList(items);
      } else {
        return emptyWidget ??
            EmptyContent(
              title: emptyTitle ?? 'Nada por aqui',
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
        if (adUnitID != null && index + 1 == items.length)
          return Container(
            height: 100,
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.only(bottom: 20.0),
            child: NativeAdmob(
              adUnitID: adUnitID,
              numberAds: 1,
              loading: CupertinoActivityIndicator(),
              controller: _nativeAdController,
              type: NativeAdmobType.banner,
            ),
          );
        return itemBuilder(context, items[index]);
      },
    );
  }
}

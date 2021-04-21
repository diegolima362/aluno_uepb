import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CustomScaffold extends StatefulWidget {
  final Widget body;
  final Widget? floatingActionButton;
  final String? textTitle;
  final String? subtitleText;
  final ScrollController? scrollController;
  final Widget? title;
  final List<Widget>? actions;

  const CustomScaffold({
    Key? key,
    required this.body,
    this.floatingActionButton,
    this.textTitle,
    this.scrollController,
    this.actions,
    this.title,
    this.subtitleText,
  })  : assert(title != null || textTitle != null),
        super(key: key);

  @override
  _CustomScaffoldState createState() => _CustomScaffoldState();
}

class _CustomScaffoldState extends State<CustomScaffold> {
  @override
  Widget build(BuildContext context) {
    final _scrollController = widget.scrollController ?? ScrollController();

    return Scaffold(
      appBar: AppBar(elevation: 0, toolbarHeight: 0),
      floatingActionButton: widget.floatingActionButton,
      body: SafeArea(
        child: NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: _buildHeader,
          body: Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: widget.body,
          ),
        ),
      ),
    );
  }

  List<Widget> _buildHeader(BuildContext context, bool _) {
    final _title = widget.textTitle ?? 'Page';
    final _subTitle = widget.subtitleText;

    return [
      SliverPadding(
        padding: const EdgeInsets.only(top: 20.0),
        sliver: SliverAppBar(
          actions: widget.actions,
          brightness: Theme.of(context).appBarTheme.brightness,
          title: widget.title != null
              ? widget.title
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _title,
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (_subTitle != null)
                      Text(
                        _subTitle,
                        style: TextStyle(
                          color: Theme.of(context).textTheme.caption!.color,
                          fontSize: 16,
                        ),
                      ),
                  ],
                ),
          backgroundColor: Theme.of(context).canvasColor,
          floating: true,
          elevation: 0,
          expandedHeight: 90.0,
        ),
      ),
    ];
  }
}

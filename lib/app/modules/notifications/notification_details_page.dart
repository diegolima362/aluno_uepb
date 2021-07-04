import 'dart:convert';

import 'package:aluno_uepb/app/modules/home/today_schedule/today_schedule_controller.dart';
import 'package:aluno_uepb/app/shared/components/components.dart';
import 'package:aluno_uepb/app/shared/repositories/data_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_modular/flutter_modular.dart';

class NotificationDetailsPage extends StatefulWidget {
  final String title = 'Notification Details';
  final String payload;

  const NotificationDetailsPage({Key? key, required this.payload})
      : super(key: key);

  @override
  _NotificationDetailsPageState createState() =>
      _NotificationDetailsPageState();
}

class _NotificationDetailsPageState extends State<NotificationDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      titleText: 'Notificações',
      floatingActionButton: _buildFAB(),
      body: _buildBody(),
    );
  }

  ListView _buildBody() {
    print(widget.payload);

    final map = json.decode(widget.payload) as Map<String, dynamic>;

    print(map);
    final text = (map['title'] ?? '').trim().split('\n');
    print(text);

    return ListView.builder(
      padding: EdgeInsets.all(2),
      itemCount: text.length,
      itemBuilder: (ctx, index) {
        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Text(
              text[index] ?? '',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFAB() {
    return CustomFAB(
      label: 'Limpar Alertas',
      tooltip: 'Limpar Alertas',
      icon: Icon(Icons.delete_sharp),
      onPressed: () async {
        await Modular.get<DataController>().deleteAlerts();
        await Modular.get<TodayScheduleController>().loadData();
        Modular.to.pop();
      },
    );
  }
}

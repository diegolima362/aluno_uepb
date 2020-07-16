import 'package:cau3pb/app/home/today_page/course_schedule_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TodaySchedulePage extends StatelessWidget {
  Widget _buildContents(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          contentPadding: EdgeInsets.only(left: 10.0, top: 20.0),
          title: Text('Aulas de Hoje', style: TextStyle(fontSize: 32.0)),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(DateFormat('MMMEd', 'pt_Br').format(DateTime.now())),
              FlatButton(
                onPressed: () {},
                child: Row(
                  children: [
                    Text(
                      'Horário completo',
                      style: TextStyle(fontSize: 10.0),
                      textAlign: TextAlign.end,
                    ),
                    Icon(Icons.arrow_forward_ios, size: 10.0),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(child: CourseScheduleCard()),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _buildContents(context),
      ),
    );
  }
}

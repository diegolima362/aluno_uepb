import 'package:cau3pb/models/models.dart';
import 'package:cau3pb/themes/custom_themes.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

final _days = {
  1: 'Segunda',
  2: 'Terça',
  3: 'Quarta',
  4: 'Quinta',
  5: 'Sexta',
};

class CourseFullInfoCard extends StatelessWidget {
  final Course course;
  final VoidCallback onTap;

  const CourseFullInfoCard({
    Key key,
    @required this.course,
    this.onTap,
  }) : super(key: key);

  List<Widget> _buildHeader(Course course) {
    return [
      ListTile(
        contentPadding: EdgeInsets.all(0),
        title: Text(
          course.title.toUpperCase(),
          style: TextStyle(
            color: CustomThemes.accentColor,
            fontWeight: FontWeight.w500,
            fontSize: 18.0,
          ),
        ),
        subtitle: Text(
          course.professor.toUpperCase(),
          style: TextStyle(
            fontSize: 16.0,
          ),
        ),
        trailing: course.isCurrentClass
            ? Icon(Icons.timer, color: CustomThemes.accentColor)
            : null,
      ),
      Row(
        children: [
          Text(
            'Carga Horária: ',
            style: TextStyle(
              fontSize: 12.0,
            ),
          ),
          Text(
            '${course.ch}',
            style: TextStyle(
              fontSize: 12.0,
            ),
          ),
        ],
      ),
    ];
  }

  List<PieChartSectionData> showingSections({
    BuildContext context,
    double current,
    double limit,
  }) {
    return List.generate(2, (i) {
      final double radius = 20;
      switch (i) {
        case 0:
          return PieChartSectionData(
            showTitle: false,
            color: limit < current ? Colors.red : CustomThemes.accentColor,
            value: current,
            radius: radius,
          );
        case 1:
          return PieChartSectionData(
            showTitle: false,
            title: '${course.absencesLimit}',
            color: Theme.of(context).canvasColor,
            value: limit < current ? 0 : limit - current,
            radius: radius,
          );
        default:
          return null;
      }
    });
  }

  Widget _buildChart(BuildContext context, Course course) {
    return Column(
      children: [
        Container(
          height: 150,
          child: PieChart(
            PieChartData(
              pieTouchData: PieTouchData(touchCallback: (_) {}),
              borderData: FlBorderData(show: false),
              sectionsSpace: 0,
              centerSpaceRadius: 25.0,
              startDegreeOffset: -90.0,
              sections: showingSections(
                context: context,
                current: course.absences.toDouble(),
                limit: course.absencesLimit.toDouble(),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text('${course.absences}/${course.absencesLimit} Faltas'),
        ),
      ],
    );
  }

  Widget _buildSchedule(Course course) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: course.schedule
          .map(
            (s) => Container(
              child: Column(
                children: [
                  Text(
                    '${_days[s.weekDay]} ${s.time}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: CustomThemes.accentColor,
                    ),
                  ),
                  Text('${s.local}', style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildGrades(Course course) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            Text('${course.und1Grade}', style: TextStyle(fontSize: 16)),
            Text(
              'Und. I',
              style: TextStyle(fontSize: 12),
            )
          ],
        ),
        Column(
          children: [
            Text('${course.und2Grade}', style: TextStyle(fontSize: 16)),
            Text(
              'Und. II',
              style: TextStyle(fontSize: 12),
            )
          ],
        ),
        Column(
          children: [
            Text('${course.finalTest}', style: TextStyle(fontSize: 16)),
            Text(
              'Prova Final',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              ..._buildHeader(course),
              _buildChart(context, course),
              const SizedBox(height: 20.0),
              _buildSchedule(course),
              const SizedBox(height: 20.0),
              _buildGrades(course),
            ],
          ),
        ),
      ),
    );
  }
}

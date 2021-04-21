import 'package:aluno_uepb/app/shared/models/models.dart';
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
  final BuildContext context;
  final CourseModel course;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Color? color;
  // final double? height;
  final double elevation;
  final bool showChart;

  const CourseFullInfoCard({
    Key? key,
    required this.course,
    required this.context,
    this.onTap,
    this.color,
    this.elevation: 2.0,
    this.showChart: true,
    this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Card(
        elevation: elevation,
        color: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              ..._buildHeader(),
              _buildChart(),
              const SizedBox(height: 10.0),
              _buildSchedule(),
              const SizedBox(height: 20.0),
              _buildGrades(),
            ],
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildCharSections() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    double current = course.absences.toDouble();
    double limit = course.absencesLimit.toDouble();

    final accent = Theme.of(context).accentColor;

    return List.generate(3, (i) {
      final double radius = 20;
      final padding = 0.33;
      final area = 0.66;
      final over = current > limit;

      final sectionA = over ? area : area * (current / limit);
      final sectionB = over ? 0.01 : area - sectionA;

      switch (i) {
        case 0:
          return PieChartSectionData(
            showTitle: false,
            title: '$current',
            color: over ? Color(0xfff05454) : accent,
            value: sectionA != 0 ? sectionA : 0.01,
            radius: radius,
          );
        case 1:
          return PieChartSectionData(
            showTitle: false,
            title: '$limit',
            color: isDark ? Colors.white.withAlpha(50) : accent.withAlpha(50),
            value: sectionB,
            radius: radius,
          );
        case 2:
          return PieChartSectionData(
            showTitle: true,
            title: '${current.toInt()}/${limit.toInt()} faltas',
            color: Colors.transparent,
            titleStyle: TextStyle(
              fontSize: 14,
              color: Theme.of(context).textTheme.bodyText1!.color,
            ),
            value: padding,
            radius: radius,
          );
        default:
          return PieChartSectionData();
      }
    });
  }

  Widget _buildChart() {
    return Container(
      height: 150,
      child: PieChart(
        PieChartData(
          pieTouchData: PieTouchData(touchCallback: (_) {}),
          borderData: FlBorderData(show: false),
          sectionsSpace: 0,
          centerSpaceRadius: 25.0,
          startDegreeOffset: 150,
          sections: _buildCharSections(),
        ),
      ),
    );
  }

  Widget _buildGrades() {
    final accent = Theme.of(context).accentColor;

    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 75,
          child: Column(
            children: [
              Text(
                '${course.und1Grade}',
                style: TextStyle(
                  fontSize: 16,
                  color: accent,
                ),
              ),
              Text(
                'Und. I',
                style: TextStyle(fontSize: 12),
              )
            ],
          ),
        ),
        Container(
          width: 75,
          child: Column(
            children: [
              Text(
                '${course.und2Grade}',
                style: TextStyle(
                  fontSize: 16,
                  color: accent,
                ),
              ),
              Text(
                'Und. II',
                style: TextStyle(fontSize: 12),
              )
            ],
          ),
        ),
        Container(
          width: 75,
          child: Column(
            children: [
              Text(
                '${course.finalTest}',
                style: TextStyle(
                  fontSize: 16,
                  color: accent,
                ),
              ),
              Text(
                'Prova Final',
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _buildHeader() {
    final accent = Theme.of(context).accentColor;

    return [
      ListTile(
        contentPadding: EdgeInsets.all(0),
        title: Text(
          course.name.toUpperCase(),
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: course.name.length > 30 ? 16.0 : 18.0,
          ),
        ),
        subtitle: Text(
          course.professor.toUpperCase(),
          style: TextStyle(
            fontSize: course.professor.length > 20 ? 15.0 : 16.0,
            color: accent,
          ),
        ),
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

  Widget _buildSchedule() {
    final accent = Theme.of(context).accentColor;
    // final isDark = Theme.of(context).brightness == Brightness.dark;

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
                    ),
                  ),
                  Text(
                    '${s.local}',
                    style: TextStyle(
                      fontSize: 12,
                      color: accent,
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

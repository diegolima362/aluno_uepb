import 'package:aluno_uepb/app/shared/models/models.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CourseInfoCardChart extends StatelessWidget {
  final CourseModel course;

  const CourseInfoCardChart({Key? key, required this.course}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      child: PieChart(
        PieChartData(
          pieTouchData: PieTouchData(touchCallback: (_) {}),
          borderData: FlBorderData(show: false),
          sectionsSpace: 0,
          centerSpaceRadius: 25.0,
          startDegreeOffset: 150,
          sections: _buildCharSections(context),
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildCharSections(BuildContext context) {
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
            color: accent,
            value: sectionA != 0 ? sectionA : 0.01,
            radius: radius,
          );
        case 1:
          return PieChartSectionData(
            showTitle: false,
            title: '$limit',
            color: isDark ? const Color(0xff252525) : const Color(0xffeeeeee),
            value: sectionB != 0 ? sectionB : 0.01,
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
}

import 'dart:io';

import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart' as pp;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

import '../../../domain/entities/course_entity.dart';
import '../../../domain/extensions/courses_extensions.dart';

Future<void> generatePdf(List<CourseEntity> courses) async {
  final days = List<int>.generate(5, (i) => i + 1);

  final atDay = <List<CourseEntity>>[];

  for (var i in days) {
    atDay.add(courses.where((c) => c.hasClassAtDay(i)).toList());
  }

  final pdf = Document(
    author: 'Aluno UEPB',
    creator: 'Aluno UEPB',
    title: 'Aulas da Semana',
    theme: ThemeData(defaultTextStyle: const TextStyle(fontSize: 8)),
  );

  final image = MemoryImage(
    (await rootBundle.load('assets/images/app_logo.png')).buffer.asUint8List(),
  );

  pdf.addPage(
    Page(
      pageFormat: PdfPageFormat.a4,
      build: (Context context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(
              image,
              fit: BoxFit.contain,
              height: 75,
              width: 75,
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: atDay.length,
                itemBuilder: (context, index) {
                  final c = atDay[index];

                  c.sort(
                    (a, b) => a
                        .scheduleAtDay(index + 1)
                        .time
                        .compareTo(b.scheduleAtDay(index + 1).time),
                  );

                  return Container(
                    width: PdfPageFormat.a4.landscape.availableWidth,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 2),
                        Container(
                          color: PdfColors.grey300,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(4, 1, 4, 1),
                            child: Text(
                              WeekDay.daysIntMap[index + 1]!,
                              style: const TextStyle(fontSize: 10),
                            ),
                          ),
                        ),
                        SizedBox(height: 2),
                        if (c.isEmpty)
                          _emptyCard()
                        else
                          _buildCourses(c, index),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    ),
  );

  final output = await pp.getTemporaryDirectory();

  final dir = Directory('${output.path}/alunoUEPB/downloads');
  if (!await dir.exists()) {
    await dir.create(recursive: true);
  }

  var path = "${output.path}/alunoUEPB/downloads/Horario.pdf";

  final file = File(path);
  await file.writeAsBytes(await pdf.save());

  await OpenFile.open(file.path);
}

Widget _emptyCard() {
  return Padding(
    padding: const EdgeInsets.only(top: 8),
    child: SizedBox(
      height: 50,
      child: Text(
        'Sem aulas',
        style: const TextStyle(fontSize: 10),
      ),
    ),
  );
}

Widget _buildCourses(List<CourseEntity> courses, int index) {
  final len = courses.length;

  if (len < 4) {
    return _buildRow(courses, index);
  } else {
    final items = <List<CourseEntity>>[];
    int currentRow = -1;

    for (int i = 0; i < len; i++) {
      final c = courses[i];

      if (i % 3 == 0) {
        items.add([c]);
        currentRow++;
      } else {
        items[currentRow].add(c);
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.map((e) => _buildRow(e, index)).toList(),
    );
  }
}

Row _buildRow(List<CourseEntity> courses, index) {
  return Row(
    mainAxisAlignment: courses.length == 3
        ? MainAxisAlignment.spaceBetween
        : MainAxisAlignment.start,
    children: [
      ...courses
          .map(
            (e) => Expanded(child: buildCourseCard(e, index)),
          )
          .toList(),
      if (courses.length < 3) Expanded(child: SizedBox(width: 10))
    ],
  );
}

Container buildCourseCard(CourseEntity course, int index) {
  final schedule = course.scheduleAtDay(index + 1);
  return Container(
    padding: const EdgeInsets.all(4),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(course.name),
        SizedBox(height: 2),
        Text(
          course.professor,
          style: const TextStyle(
            color: PdfColors.grey,
          ),
        ),
        SizedBox(height: 2),
        Text('${schedule.time} - ${schedule.local}'),
      ],
    ),
  );
}

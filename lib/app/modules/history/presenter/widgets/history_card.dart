import 'package:flutter/material.dart';

import '../../domain/entities/entities.dart';

class HistoryCard extends StatelessWidget {
  final HistoryEntity info;

  const HistoryCard({Key? key, required this.info}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.all(4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(info.name),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            children: [
              _TextItem(text: 'Status', value: info.status),
              _TextItem(text: 'Média', value: info.grade),
              _TextItem(text: 'Faltas', value: info.absences),
              _TextItem(text: 'C.H.', value: info.cumulativeHours),
            ],
          ),
        ],
      ),
    );
  }
}

class _TextItem extends StatelessWidget {
  final String text;
  final String value;

  const _TextItem({Key? key, required this.text, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return RichText(
      text: TextSpan(
        text: '$text: ',
        style: textTheme.bodyLarge,
        children: [
          TextSpan(
            text: value,
            style: textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

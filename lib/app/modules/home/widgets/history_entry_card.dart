import 'package:aluno_uepb/app/shared/models/history_entry_model.dart';
import 'package:flutter/material.dart';

class HistoryEntryCard extends StatelessWidget {
  final HistoryEntryModel history;

  const HistoryEntryCard({Key? key, required this.history}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        padding: EdgeInsets.all(8),
        height: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Text(
                      history.name,
                      maxLines: 2,
                    ),
                  ),
                  _CustomText('Semestre', history.semester),
                  _CustomText('Nota', history.grade.toString()),
                ],
              ),
            ),
            Container(
              width: 80,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                children: [
                  _CustomText('CH', history.ch.toString()),
                  if (history.absences > 0)
                    _CustomText('Faltas', history.absences.toString()),
                  _CustomText('Status', history.status),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomText extends StatelessWidget {
  final String text;
  final String value;

  _CustomText(this.text, this.value, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final captionStyle = TextStyle(
      color: Theme.of(context).textTheme.caption!.color,
      fontSize: 16,
    );

    final titleStyle = TextStyle(
      color: Theme.of(context).textTheme.headline6!.color,
      fontSize: 16,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('$text: ', style: titleStyle),
        Text(value, style: captionStyle),
      ],
    );
  }
}

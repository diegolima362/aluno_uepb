import 'package:aluno_uepb/app/shared/models/task_model.dart';
import 'package:aluno_uepb/app/utils/format.dart';
import 'package:flutter/material.dart';

class TaskInfoCard extends StatelessWidget {
  final TaskModel task;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final bool extended;
  final bool short;
  final bool marked;
  final bool deleteMode;

  const TaskInfoCard({
    Key key,
    @required this.task,
    this.onTap,
    this.onLongPress,
    this.extended: false,
    this.marked: false,
    this.deleteMode: false,
    this.short: false,
  })  : assert(short == false || extended == false),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final accentColor = Theme.of(context).accentColor;

    Icon leading;

    if (deleteMode) {
      leading = marked ? Icon(Icons.delete) : Icon(Icons.delete_outline);
    }

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Card(
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                contentPadding: EdgeInsets.all(0),
                leading: leading,
                title: Text(
                  task.title,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                    color: accentColor,
                  ),
                ),
                subtitle: short == true
                    ? null
                    : Text(
                        task.courseTitle,
                        style: TextStyle(fontSize: 14.0),
                      ),
                trailing: task.isCompleted
                    ? Icon(Icons.done, color: accentColor)
                    : null,
              ),
              if (extended) Text(task.text),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    Format.date(task.dueDate),
                    style: TextStyle(
                      fontSize: 12.0,
                    ),
                  ),
                  Text(
                    Format.hours(task.dueDate),
                    style: TextStyle(fontSize: 12.0),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

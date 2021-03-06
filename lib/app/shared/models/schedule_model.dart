final _weekDaysMap = {
  'seg': 1,
  'ter': 2,
  'qua': 3,
  'qui': 4,
  'sex': 5,
  'sab': 6,
  'dom': 7,
};

class ScheduleModel {
  final String day;
  final String time;
  final String local;

  ScheduleModel({this.day: 'seg', this.time: 'time', this.local: 'local'});

  int get weekDay => _weekDaysMap[this.day.substring(0, 3).toLowerCase()] ?? 1;

  Map<String, dynamic> toMap() => {
        'day': this.day,
        'time': this.time,
        'local': this.local,
      };

  factory ScheduleModel.fromMap(Map<dynamic, dynamic> map) {
    return ScheduleModel(
      day: map['day'] as String,
      time: map['time'] as String,
      local: map['local'] as String,
    );
  }

  @override
  String toString() => '{ ${this.day}, ${this.time}, ${this.local} }';
}

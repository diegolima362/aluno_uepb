final _weekDaysMap = {
  'seg': 1,
  'ter': 2,
  'qua': 3,
  'qui': 4,
  'sex': 5,
  'sab': 6,
  'dom': 7,
};

class Schedule {
  final String day;
  final String time;
  final String local;

  Schedule({this.day, this.time, this.local});

  int get weekDay => _weekDaysMap[this.day.substring(0, 3).toLowerCase()];

  Map<String, dynamic> toMap() => {
        'day': this.day,
        'time': this.time,
        'local': this.local,
      };

  factory Schedule.fromMap(Map<dynamic, dynamic> map) {
    return Schedule(
      day: map['day'] as String,
      time: map['time'] as String,
      local: map['local'] as String,
    );
  }

  @override
  String toString() => '{ ${this.day}, ${this.time}, ${this.local} }';
}

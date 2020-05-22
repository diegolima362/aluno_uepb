class Schedule {
  final String day;
  final String time;
  final String local;

  Schedule({this.day, this.time, this.local});

  Map<String, dynamic> toJson() => {
        'day': this.day,
        'time': this.time,
        'local': this.local,
      };

  factory Schedule.fromJson(dynamic json) {
    return Schedule(
      day: json['day'] as String,
      time: json['time'] as String,
      local: json['local'] as String,
    );
  }

  @override
  String toString() => '{ ${this.day}, ${this.time}, ${this.local} }';
}

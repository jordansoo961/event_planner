import 'package:hive/hive.dart';

part 'event_model.g.dart';

@HiveType(typeId: 1)
class Event extends HiveObject {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final DateTime date;

  @HiveField(2)
  final String location;

  @HiveField(3)
  final String description;

  @HiveField(4)
  bool? isAttending;

  Event({
    required this.title,
    required this.date,
    required this.location,
    required this.description,
    this.isAttending
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'date': date.toIso8601String(),
      'location': location,
      'description': description,
      'isAttending': isAttending
    };
  }

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      title: map['title'],
      date: DateTime.parse(map['date']),
      location: map['location'],
      description: map['description'],
      isAttending: map['isAttending']
    );
  }
}

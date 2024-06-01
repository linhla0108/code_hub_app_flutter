import 'activity.dart';

class History {
  final int id;
  final String date;
  final int total;
  final List<ActivityEntity> activities;

  History({
    required this.id,
    required this.date,
    required this.total,
    required this.activities,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date,
        'total': total,
        'activities': activities.map((activity) => activity.toJson()).toList(),
      };

  @override
  String toString() {
    return 'History {id: $id, date: $date, total: $total, activities: $activities}';
  }
}

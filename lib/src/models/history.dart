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

  @override
  String toString() {
    return 'History {id: $id, date: $date, total: $total, activities: $activities}';
  }
}

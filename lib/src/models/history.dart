class History {
  final int id;
  final String date;
  final int total;
  final List<Activity> activities;

  History({
    required this.id,
    required this.date,
    required this.total,
    required this.activities,
  });

  @override
  String toString() {
    return 'History{id: $id, date: $date, total: $total, activities: $activities}';
  }
}

class Activity {
  final int type;
  final int percentage;

  Activity({required this.type, required this.percentage});

  @override
  String toString() {
    return 'History{type: $type, percentage: $percentage}';
  }
}

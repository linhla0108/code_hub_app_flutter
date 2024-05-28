class ActivityEntity {
  final int type;
  final int percentage;

  ActivityEntity({required this.type, required this.percentage});

  @override
  String toString() {
    return 'History{type: $type, percentage: $percentage}';
  }
}

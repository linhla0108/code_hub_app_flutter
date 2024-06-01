class ActivityEntity {
  final int type;
  final int value;

  ActivityEntity({required this.type, required this.value});

  Map<String, dynamic> toJson() => {
        'type': type,
        'value': value,
      };

  @override
  String toString() {
    return 'History{type: $type, value: $value}';
  }
}

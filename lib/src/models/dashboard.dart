import 'package:dans_productivity_app_flutter/src/models/activity.dart';

// class DashboardEntity {
//   final String lable;
//   final int total;
//   final List<ActivityEntity> activities;

//   DashboardEntity({
//     required this.lable,
//     required this.total,
//     required this.activities,
//   });
// }

// class DataDashboardEntity {
//   final List<DashboardEntity> data;

//   DataDashboardEntity({
//     required this.data,
//   });
// }

///

class DashboardEntity {
  final String label;
  final int total;
  final List<ActivityEntity> activities;

  DashboardEntity({
    required this.label,
    required this.total,
    required this.activities,
  });

  @override
  String toString() {
    return 'DashboardEntity {label: $label, total: $total, activities: $activities}';
  }
}

class DashboardData {
  final DashboardEntity data;
  DashboardData({
    required this.data,
  });

  @override
  String toString() {
    return 'DashboardData {data: $data}';
  }
}

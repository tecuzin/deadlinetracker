class Deadline {
  final String id;
  final String title;
  final String description;
  final DateTime dueDate;
  final DateTime createdAt;

  Deadline({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.createdAt,
  });

  // Calculate remaining time
  Duration get remainingTime {
    return dueDate.difference(DateTime.now());
  }

  // Get remaining time as a human-readable string
  String get remainingTimeString {
    final duration = remainingTime;
    
    if (duration.isNegative) {
      final absDuration = duration.abs();
      if (absDuration.inDays > 0) {
        return '${absDuration.inDays}d overdue';
      } else if (absDuration.inHours > 0) {
        return '${absDuration.inHours}h overdue';
      } else if (absDuration.inMinutes > 0) {
        return '${absDuration.inMinutes}m overdue';
      } else {
        return 'Just overdue';
      }
    }
    
    if (duration.inDays > 0) {
      final hours = duration.inHours % 24;
      return '${duration.inDays}d ${hours}h';
    } else if (duration.inHours > 0) {
      final minutes = duration.inMinutes % 60;
      return '${duration.inHours}h ${minutes}m';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m';
    } else {
      return 'Due now!';
    }
  }

  // Check if deadline is overdue
  bool get isOverdue {
    return DateTime.now().isAfter(dueDate);
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Create from JSON
  factory Deadline.fromJson(Map<String, dynamic> json) {
    return Deadline(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      dueDate: DateTime.parse(json['dueDate']),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

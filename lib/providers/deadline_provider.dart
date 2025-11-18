import 'package:flutter/foundation.dart';
import '../models/deadline.dart';

class DeadlineProvider extends ChangeNotifier {
  final List<Deadline> _deadlines = [];

  List<Deadline> get deadlines {
    // Sort deadlines from earliest to latest
    final sortedDeadlines = List<Deadline>.from(_deadlines);
    sortedDeadlines.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    return sortedDeadlines;
  }

  void addDeadline(Deadline deadline) {
    _deadlines.add(deadline);
    notifyListeners();
  }

  void removeDeadline(String id) {
    _deadlines.removeWhere((deadline) => deadline.id == id);
    notifyListeners();
  }

  void updateDeadline(Deadline updatedDeadline) {
    final index = _deadlines.indexWhere((d) => d.id == updatedDeadline.id);
    if (index != -1) {
      _deadlines[index] = updatedDeadline;
      notifyListeners();
    }
  }
}

import 'dart:async';

import 'package:flutter/foundation.dart';

final stepController = StepController._();

final class StepController extends ChangeNotifier {
  StepController._();

  var _current = Step.welcome;
  Step get current => _current;

  final previous = <Step>[];
  List<Step> get currentAndPrevious => [...previous, _current];

  Timer? _nextStepTimer;
  void markStepComplete(Step step, {bool delayNext = true}) {
    if (current > step) return;
    if (current < step) {
      throw StateError(
        'Cannot mark step $step as complete, current step is $_current',
      );
    }

    if (delayNext) {
      if (_nextStepTimer?.isActive ?? false) return;
      _nextStepTimer = Timer(const Duration(milliseconds: 300), _goToNextStep);
    } else {
      _goToNextStep();
    }
  }

  void _goToNextStep() {
    _nextStepTimer?.cancel();
    final next = _current.next;
    if (next == null) {
      // No next step, do nothing
    } else {
      previous.add(_current);
      _current = next;
      notifyListeners();
    }
  }
}

enum Step {
  welcome(next: Step.findPrismLauncher),
  findPrismLauncher(next: Step.selectInstance),
  selectInstance(next: null);

  const Step({required this.next});
  final Step? next;

  bool operator >=(Step other) => index >= other.index;
  bool operator <=(Step other) => index <= other.index;
  bool operator >(Step other) => index > other.index;
  bool operator <(Step other) => index < other.index;
}

import 'dart:async';

import 'package:flutter/services.dart';

final class Haptics {
  const Haptics._();

  static void light() {
    unawaited(HapticFeedback.lightImpact());
  }

  static void medium() {
    unawaited(HapticFeedback.mediumImpact());
  }

  static void selection() {
    unawaited(HapticFeedback.selectionClick());
  }
}

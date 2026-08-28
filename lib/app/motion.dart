import 'package:flutter/material.dart';

final class AppMotion {
  const AppMotion._();

  static const popupMenu = AnimationStyle(
    // PopupMenuRoute feeds this value into internal Interval curves.
    // Overshooting curves would pass values greater than 1 to those curves.
    curve: Curves.easeOutCubic,
    reverseCurve: Curves.easeInCubic,
    duration: Duration(milliseconds: 300),
    reverseDuration: Duration(milliseconds: 180),
  );

  // The outgoing motion may overshoot slightly, but the return motion must
  // stay on the same side of zero so the opposite swipe background never
  // flashes during a reset.
  static const swipe = Curves.easeOutBack;
  static const swipeReturn = Curves.easeOutCubic;
}

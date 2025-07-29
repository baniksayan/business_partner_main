import 'package:flutter/material.dart';

class AnimationHelper {
  // Animation Durations
  static const Duration fastDuration = Duration(milliseconds: 300);
  static const Duration normalDuration = Duration(milliseconds: 500);
  static const Duration slowDuration = Duration(milliseconds: 800);
  static const Duration splashDuration = Duration(milliseconds: 3500);

  // Animation Curves
  static const Curve elasticCurve = Curves.elasticOut;
  static const Curve bounceCurve = Curves.bounceOut;
  static const Curve easeCurve = Curves.easeInOut;

  // Create slide animation
  static Animation<Offset> createSlideAnimation({
    required AnimationController controller,
    required Offset beginOffset,
    Offset endOffset = Offset.zero,
    Curve curve = Curves.easeOutBack,
  }) {
    return Tween<Offset>(
      begin: beginOffset,
      end: endOffset,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: curve,
    ));
  }

  // Create scale animation
  static Animation<double> createScaleAnimation({
    required AnimationController controller,
    double begin = 0.0,
    double end = 1.0,
    Curve curve = Curves.elasticOut,
  }) {
    return Tween<double>(
      begin: begin,
      end: end,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: curve,
    ));
  }

  // Create fade animation
  static Animation<double> createFadeAnimation({
    required AnimationController controller,
    double begin = 0.0,
    double end = 1.0,
    Curve curve = Curves.easeIn,
  }) {
    return Tween<double>(
      begin: begin,
      end: end,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: curve,
    ));
  }
}

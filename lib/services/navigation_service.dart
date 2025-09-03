import 'package:flutter/material.dart';

class NavigationService {
  // Make this static so it can be accessed from MaterialApp
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<dynamic> navigateTo(String routeName, {Object? arguments}) {
    return navigatorKey.currentState!.pushNamed(routeName, arguments: arguments);
  }

  Future<dynamic> navigateToAndClearStack(String routeName, {Object? arguments}) {
    return navigatorKey.currentState!.pushNamedAndRemoveUntil(
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }

  Future<dynamic> pushReplacement(String routeName, {Object? arguments}) {
    return navigatorKey.currentState!.pushReplacementNamed(routeName, arguments: arguments);
  }

  void goBack({Object? result}) {
    navigatorKey.currentState!.pop(result);
  }

  bool canGoBack() {
    return navigatorKey.currentState!.canPop();
  }

  void popUntil(String routeName) {
    navigatorKey.currentState!.popUntil(ModalRoute.withName(routeName));
  }

  // Get current context (useful for showing dialogs, etc.)
  BuildContext? get currentContext => navigatorKey.currentContext;
}

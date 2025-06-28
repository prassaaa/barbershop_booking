import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey = 
      GlobalKey<NavigatorState>();
  
  static BuildContext? get context => navigatorKey.currentContext;
  
  // Navigation methods
  static void pop([Object? result]) {
    if (context != null) {
      Navigator.of(context!).pop(result);
    }
  }
  
  static void popUntil(String routeName) {
    if (context != null) {
      Navigator.of(context!).popUntil(ModalRoute.withName(routeName));
    }
  }
  
  static Future<T?> push<T>(Widget page) {
    if (context != null) {
      return Navigator.of(context!).push<T>(
        MaterialPageRoute(builder: (_) => page),
      );
    }
    return Future.value(null);
  }
  
  static Future<T?> pushReplacement<T>(Widget page) {
    if (context != null) {
      return Navigator.of(context!).pushReplacement<T, Object?>(
        MaterialPageRoute(builder: (_) => page),
      );
    }
    return Future.value(null);
  }
  
  static Future<T?> pushAndRemoveUntil<T>(Widget page, String untilRoute) {
    if (context != null) {
      return Navigator.of(context!).pushAndRemoveUntil<T>(
        MaterialPageRoute(builder: (_) => page),
        ModalRoute.withName(untilRoute),
      );
    }
    return Future.value(null);
  }
  
  // GoRouter methods (will be used later)
  static void go(String path) {
    if (context != null) {
      context!.go(path);
    }
  }
  
  static void goNamed(String name, {Map<String, String>? pathParameters}) {
    if (context != null) {
      context!.goNamed(name, pathParameters: pathParameters ?? {});
    }
  }
  
  static Future<T?> pushNamed<T>(String name, {Map<String, String>? pathParameters}) {
    if (context != null) {
      return context!.pushNamed<T>(name, pathParameters: pathParameters ?? {});
    }
    return Future.value(null);
  }
}
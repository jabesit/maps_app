import 'package:flutter/material.dart';


Future<Widget> createTestApp({
  Widget? child,
  List<NavigatorObserver>? navigatorObservers,
  Map<String, WidgetBuilder>? routes,
}) async {

  return MaterialApp(
      home: Scaffold(
        body: child,
      ),
      routes: routes ?? {},
      navigatorObservers: navigatorObservers ?? []);
}

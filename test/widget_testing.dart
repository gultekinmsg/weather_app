// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/main.dart';

void main() {
  testWidgets("Flutter Widget Test", (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());
    var textField = find.byType(TextField);
    expect(textField, findsOneWidget);
  });

  testWidgets("Flutter Widget Test", (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());
    var textField = find.byType(TextField);
    expect(textField, findsOneWidget);
    await tester.enterText(textField, 'Flutter Devs');
    expect(find.text('Flutter Devs'), findsOneWidget);
    print('Flutter Devs');
  });

  testWidgets("Flutter Widget Test", (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());
    var textField = find.byType(TextField);
    expect(textField, findsOneWidget);
    await tester.enterText(textField, 'Flutter Devs');
    expect(find.text('Flutter Devs'), findsOneWidget);
    print('Flutter Devs');
    var button = find.text("Reverse Text");
    expect(button, findsOneWidget);
    print('Reverse Text');
    await tester.tap(button);
    await tester.pump();
    expect(find.text("sveD rettulF"), findsOneWidget);
    print('sveD rettulF');
  });

  testWidgets("Flutter Widget Test", (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());
    var button = find.text("Reverse Text");
    expect(button, findsOneWidget);
    print('Reverse Text');
    await tester.tap(button);
    await tester.pump();
    expect(find.text("sveD rettulF"), findsNothing);
    print('sveD rettulF');
  });
}

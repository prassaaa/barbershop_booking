import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:barbershop_booking/main.dart';

void main() {
  testWidgets('App should start without crashing', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const BarbershopBookingApp());

    // Verify that the app starts
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
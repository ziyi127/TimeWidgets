import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:time_widgets/main.dart';

void main() {
  testWidgets('TimeWidgetsApp builds', (tester) async {
    await tester.pumpWidget(const TimeWidgetsApp());
    await tester.pump();
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}

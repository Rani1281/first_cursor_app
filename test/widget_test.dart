// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:first_cursor_app/main.dart';

void main() {
  testWidgets('User can add a task with a target date', (tester) async {
    await tester.pumpWidget(const TodoApp());

    expect(find.text('No tasks yet'), findsOneWidget);

    await tester.tap(find.text('Add task'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, 'Buy groceries');

    await tester.tap(find.text('Set target date'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('OK')); // Accept the default date.
    await tester.pumpAndSettle();

    await tester.tap(find.text('Save task'));
    await tester.pumpAndSettle();

    expect(find.text('Buy groceries'), findsOneWidget);
    expect(find.textContaining('Due'), findsWidgets);
  });
}

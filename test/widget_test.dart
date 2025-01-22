import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {
  testWidgets('Add Task and display it in the list',
      (WidgetTester tester) async {
    await tester.pumpWidget(const ToDoApp());

    expect(find.text('No tasks added yet!'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Test Task');
    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('High').last);
    await tester.pump();

    await tester.tap(find.text('Add Task'));
    await tester.pump();

    expect(find.text('No tasks added yet!'), findsNothing);
    expect(find.text('Test Task'), findsOneWidget);
    expect(find.text('High'), findsNothing);
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:semester_project/app.dart';

void main() {
  testWidgets('App starts successfully', (tester) async {
    await tester.pumpWidget(const SemesterProjectApp());

    expect(find.text('Your System'), findsOneWidget);
  });
}

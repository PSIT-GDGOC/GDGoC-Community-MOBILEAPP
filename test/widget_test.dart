import 'package:flutter_test/flutter_test.dart';
import 'package:gdgoc_psit_app/main.dart';

void main() {
  testWidgets('GdgApp launches landing screen successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const GdgApp());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('GDG on\nCampus\nPSIT'), findsOneWidget);
    expect(find.text('Join the chapter'), findsWidgets);
  });
}

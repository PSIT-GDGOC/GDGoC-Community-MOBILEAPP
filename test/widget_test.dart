import 'package:flutter_test/flutter_test.dart';
import 'package:gdgoc_psit_app/main.dart';

void main() {
  testWidgets('GdgApp foundation smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const GdgApp());
    await tester.pumpAndSettle();

    expect(find.text('GDGoC PSIT'), findsOneWidget);
    expect(find.text('Foundation Ready'), findsOneWidget);
    expect(find.text('Design System Ready'), findsOneWidget);
  });
}

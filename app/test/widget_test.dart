import 'package:flutter_test/flutter_test.dart';
import 'package:aiish_app/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const AiishApp());
    expect(find.byType(AiishApp), findsOneWidget);
  });
}

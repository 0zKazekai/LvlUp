import 'package:flutter_test/flutter_test.dart';
import 'package:lvlup_habit_tracker_ai_coach/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const LvlUpApp());
    expect(find.byType(LvlUpApp), findsOneWidget);
  });
}

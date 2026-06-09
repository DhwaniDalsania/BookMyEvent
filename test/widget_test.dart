import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:book_my_event/main.dart';

void main() {
  testWidgets('App loads without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: BookMyEventApp()));
    await tester.pump();
    expect(find.byType(BookMyEventApp), findsOneWidget);
    await tester.pump(const Duration(seconds: 4));
  });
}

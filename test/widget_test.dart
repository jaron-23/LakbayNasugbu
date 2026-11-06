
import 'package:flutter_test/flutter_test.dart';
import 'package:lakbay_nasugbu/main.dart';

void main() {
  testWidgets('LakbayNasugbu app launches successfully',
          (WidgetTester tester) async {
        await tester.pumpWidget(const LakbayNasugbuApp());

        expect(find.byType(LakbayNasugbuApp), findsOneWidget);
      });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:nooshora_admin/main.dart';

void main() {
  testWidgets('dashboard renders primary management metrics', (tester) async {
    await tester.pumpWidget(const NooshoraAdminApp());
    await tester.pumpAndSettle();

    expect(find.text('فروش امروز'), findsOneWidget);
    expect(find.text('سفارش جدید'), findsOneWidget);
    expect(find.text('هشدار موجودی'), findsOneWidget);
  });
}

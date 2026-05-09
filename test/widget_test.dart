import 'package:flutter_test/flutter_test.dart';
import 'package:naila_shop_final/main.dart';

void main() {
  testWidgets('App loads BlueMart shell', (tester) async {
    await tester.pumpWidget(const PraktikumEnamApp());
    expect(find.text('BlueMart'), findsOneWidget);
  });
}

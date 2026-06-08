import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_veterinaria/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const VeterinariaApp());
    expect(find.text('Clínica Veterinaria'), findsOneWidget);
  });
}

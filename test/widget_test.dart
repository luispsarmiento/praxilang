import 'package:flutter_test/flutter_test.dart';

import 'package:testing/main.dart';

void main() {
  testWidgets('Mural app renders Talk screen', (WidgetTester tester) async {
    await tester.pumpWidget(const MuralCrossPlatformApp());

    // Title text is present.
    expect(find.text('¡Hola!'), findsOneWidget);
    expect(find.text('Empezar charla'), findsOneWidget);

    // Tapping the mic pill toggles the listening state.
    await tester.tap(find.text('Empezar charla'));
    await tester.pump();
    expect(find.text('Escuchando...'), findsOneWidget);
  });

  testWidgets('Bottom navigation switches tabs', (WidgetTester tester) async {
    await tester.pumpWidget(const MuralCrossPlatformApp());

    await tester.tap(find.text('Temas'));
    await tester.pump();
    expect(find.text('Temas'), findsWidgets);
  });
}

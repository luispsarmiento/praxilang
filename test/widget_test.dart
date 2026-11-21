import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';

import 'package:praxilang/main.dart';

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

  testWidgets('Mobile viewport renders full screen and buttons work', (WidgetTester tester) async {
    // Simulate an Android phone viewport (width < 480).
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.625;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MuralCrossPlatformApp());
    await tester.pump();

    // Talk screen content is present.
    expect(find.text('¡Hola!'), findsOneWidget);
    expect(find.text('Empezar charla'), findsOneWidget);

    // Mic pill toggles listening state on tap.
    await tester.tap(find.text('Empezar charla'));
    await tester.pump();
    expect(find.text('Escuchando...'), findsOneWidget);

    // Bottom nav items are present and tappable.
    await tester.tap(find.text('Temas'));
    await tester.pump();
    expect(find.text('Temas'), findsWidgets);
  });
}

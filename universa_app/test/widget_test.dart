import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:universa_app/src/app_universa.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  testWidgets('exibe tela de login', (WidgetTester tester) async {
    await tester.pumpWidget(const AppUniversa());

    expect(find.text('Universa'), findsOneWidget);
    expect(find.text('Portal Academico'), findsOneWidget);
    expect(find.text('Entrar'), findsOneWidget);
  });

  testWidgets('navega para dash central apos login', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(400, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const AppUniversa());

    await tester.ensureVisible(find.byType(OutlinedButton));
    await tester.tap(find.byType(OutlinedButton));
    await tester.pumpAndSettle(const Duration(seconds: 2));

    expect(find.text('Olá, Natalia'), findsOneWidget);
    expect(find.text('RESUMO ACADEMICO'), findsOneWidget);
    expect(find.text('IRA'), findsOneWidget);
    expect(find.text('Calculo III'), findsNWidgets(3));
    expect(find.text('Inicio'), findsOneWidget);
  });
}

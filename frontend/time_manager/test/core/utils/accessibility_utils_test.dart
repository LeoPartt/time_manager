import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:time_manager/core/utils/accessibility_utils.dart';

void main() {
testWidgets('ensureContrast returns proper color based on theme brightness', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      theme: ThemeData(brightness: Brightness.light),
      home: Builder(builder: (context) {
        final color = AccessibilityUtils.ensureContrast(context, Colors.white);
        expect(color, Colors.black); // ✅ light -> black
        return const SizedBox();
      }),
    ),
  );

  await tester.pumpWidget(
    MaterialApp(
      theme: ThemeData(brightness: Brightness.dark),
      home: Builder(builder: (context) {
        final color = AccessibilityUtils.ensureContrast(context, Colors.white);
        expect(color, Colors.black); 
        return const SizedBox();
      }),
    ),
  );
});


  testWidgets('accessibleText scales with textScaleFactor', (tester) async {
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(1.4)),
        child: Builder(builder: (context) {
          final result = AccessibilityUtils.accessibleText(context, 16);
          expect(result, greaterThan(16));
          return const SizedBox();
        }),
      ),
    );
  });

  // testWidgets('withTooltip shows tooltip message', (tester) async {
  //   await tester.pumpWidget(
  //     MaterialApp(
  //       home: AccessibilityUtils.withTooltip(
          
  //         tooltip: 'Info tooltip',
  //         child: const Icon(Icons.info),
  //       ),
  //     ),
  //   );

  //   final iconFinder = find.byIcon(Icons.info);
  //   expect(iconFinder, findsOneWidget);
  // });
}

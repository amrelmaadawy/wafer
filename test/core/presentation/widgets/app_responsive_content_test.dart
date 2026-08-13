import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wafer/core/presentation/widgets/app_responsive_content.dart';

void main() {
  testWidgets('uses compact horizontal padding', (tester) async {
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AppResponsiveContent(child: SizedBox(key: Key('content'))),
        ),
      ),
    );

    final padding = tester.widget<Padding>(
      find.ancestor(
        of: find.byKey(const Key('content')),
        matching: find.byType(Padding),
      ),
    );
    expect(padding.padding, const EdgeInsets.symmetric(horizontal: 16));
  });

  testWidgets('constrains expanded content width', (tester) async {
    tester.view.physicalSize = const Size(1800, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AppResponsiveContent(
            child: SizedBox.expand(key: Key('content')),
          ),
        ),
      ),
    );

    expect(tester.getSize(find.byKey(const Key('content'))).width, 1376);
  });
}

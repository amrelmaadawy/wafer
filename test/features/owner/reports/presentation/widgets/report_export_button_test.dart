import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wafer/features/owner/reports/presentation/widgets/report_export_button.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
  });

  testWidgets('opens both supported export choices', (tester) async {
    await _pumpExportButton(
      tester,
      ReportExportButton(onPdfPressed: () {}, onExcelPressed: () {}),
    );

    await tester.tap(find.byIcon(Icons.print_rounded));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.picture_as_pdf), findsOneWidget);
    expect(find.byIcon(Icons.table_chart), findsOneWidget);
  });

  testWidgets('invokes the selected export callback', (tester) async {
    var pdfExports = 0;
    await _pumpExportButton(
      tester,
      ReportExportButton(
        onPdfPressed: () => pdfExports++,
        onExcelPressed: () {},
      ),
    );

    await tester.tap(find.byIcon(Icons.print_rounded));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.picture_as_pdf));
    await tester.pumpAndSettle();

    expect(pdfExports, 1);
    expect(find.byIcon(Icons.picture_as_pdf), findsNothing);
  });
}

Future<void> _pumpExportButton(WidgetTester tester, Widget child) async {
  await tester.pumpWidget(
    EasyLocalization(
      supportedLocales: const [Locale('ar'), Locale('en')],
      path: 'assets/translations',
      startLocale: const Locale('en'),
      fallbackLocale: const Locale('en'),
      saveLocale: false,
      assetLoader: const _TestAssetLoader(),
      child: _LocalizedTestApp(child: child),
    ),
  );
  await tester.pumpAndSettle();
}

class _TestAssetLoader extends AssetLoader {
  const _TestAssetLoader();

  @override
  Future<Map<String, dynamic>> load(String path, Locale locale) async => {
    'reports': {
      'export': 'Export',
      'exportTitle': 'Export report',
      'exportPdf': 'Export as PDF',
      'exportExcel': 'Export as Excel',
    },
  };
}

class _LocalizedTestApp extends StatelessWidget {
  const _LocalizedTestApp({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      home: Scaffold(body: child),
    );
  }
}

import 'package:flutter_test/flutter_test.dart';
import 'package:wafer/core/theme/app_breakpoints.dart';

void main() {
  group('AppBreakpoints', () {
    test('classifies compact widths', () {
      expect(AppBreakpoints.windowSizeFor(320), AppWindowSize.compact);
      expect(AppBreakpoints.windowSizeFor(599), AppWindowSize.compact);
      expect(AppBreakpoints.horizontalPaddingFor(375), 16);
    });

    test('classifies medium widths', () {
      expect(AppBreakpoints.windowSizeFor(600), AppWindowSize.medium);
      expect(AppBreakpoints.windowSizeFor(1023), AppWindowSize.medium);
      expect(AppBreakpoints.horizontalPaddingFor(800), 24);
    });

    test('classifies expanded widths', () {
      expect(AppBreakpoints.windowSizeFor(1024), AppWindowSize.expanded);
      expect(AppBreakpoints.horizontalPaddingFor(1440), 32);
    });
  });
}

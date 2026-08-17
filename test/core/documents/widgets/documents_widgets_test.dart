import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wafer/core/documents/entities/document_item_entity.dart';
import 'package:wafer/core/documents/widgets/document_item_widget.dart';
import 'package:wafer/core/documents/widgets/document_type_badge.dart';
import 'package:wafer/core/documents/widgets/documents_list_widget.dart';

Widget _wrapWithApp(Widget child) {
  return MaterialApp(
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF3B82F6)),
    ),
    home: Scaffold(body: child),
  );
}

void main() {
  group('DocumentTypeBadge', () {
    testWidgets('renders PDF badge', (tester) async {
      await tester.pumpWidget(
        _wrapWithApp(
          const DocumentTypeBadge(type: DocumentType.pdf),
        ),
      );

      expect(find.byType(DocumentTypeBadge), findsOneWidget);
    });

    testWidgets('renders Image badge', (tester) async {
      await tester.pumpWidget(
        _wrapWithApp(
          const DocumentTypeBadge(type: DocumentType.image),
        ),
      );

      expect(find.byType(DocumentTypeBadge), findsOneWidget);
    });
  });

  group('DocumentItemWidget', () {
    testWidgets('renders document name and details', (tester) async {
      const doc = DocumentItemEntity(
        id: '101',
        name: 'Deed Document.pdf',
        url: 'https://example.com/deed.pdf',
        fileSize: '1.8 MB',
        createdAt: '2026-08-17',
        type: DocumentType.pdf,
      );

      await tester.pumpWidget(
        _wrapWithApp(
          const DocumentItemWidget(document: doc),
        ),
      );

      expect(find.text('Deed Document.pdf'), findsOneWidget);
      expect(find.text('1.8 MB • 2026-08-17'), findsOneWidget);
      expect(find.byIcon(Icons.picture_as_pdf_outlined), findsOneWidget);
    });

    testWidgets('triggers onTap callback when tapped', (tester) async {
      bool tapped = false;
      const doc = DocumentItemEntity(
        id: '102',
        name: 'Floor Plan.png',
        url: 'https://example.com/plan.png',
        type: DocumentType.image,
      );

      await tester.pumpWidget(
        _wrapWithApp(
          DocumentItemWidget(
            document: doc,
            onTap: () => tapped = true,
          ),
        ),
      );

      await tester.tap(find.byType(InkWell));
      expect(tapped, isTrue);
    });
  });

  group('DocumentsListWidget', () {
    testWidgets('renders empty state when documents list is empty', (tester) async {
      await tester.pumpWidget(
        _wrapWithApp(
          const DocumentsListWidget(
            documents: [],
            emptyTitle: 'No Documents',
          ),
        ),
      );

      expect(find.text('No Documents'), findsOneWidget);
    });

    testWidgets('renders items when documents list is not empty', (tester) async {
      final docs = [
        const DocumentItemEntity(
          id: '1',
          name: 'Doc 1.pdf',
          url: 'https://example.com/1.pdf',
          type: DocumentType.pdf,
        ),
        const DocumentItemEntity(
          id: '2',
          name: 'Doc 2.png',
          url: 'https://example.com/2.png',
          type: DocumentType.image,
        ),
      ];

      await tester.pumpWidget(
        _wrapWithApp(
          DocumentsListWidget(documents: docs),
        ),
      );

      expect(find.text('Doc 1.pdf'), findsOneWidget);
      expect(find.text('Doc 2.png'), findsOneWidget);
      expect(find.byType(DocumentItemWidget), findsNWidgets(2));
    });
  });
}

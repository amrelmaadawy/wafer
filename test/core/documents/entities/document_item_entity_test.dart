import 'package:flutter_test/flutter_test.dart';
import 'package:wafer/core/documents/entities/document_item_entity.dart';

void main() {
  group('DocumentType', () {
    test('fromMimeOrUrl correctly identifies PDF from mime', () {
      final type = DocumentType.fromMimeOrUrl(mimeType: 'application/pdf');
      expect(type, equals(DocumentType.pdf));
    });

    test('fromMimeOrUrl correctly identifies PDF from url', () {
      final type = DocumentType.fromMimeOrUrl(url: 'https://example.com/contract.pdf?v=1');
      expect(type, equals(DocumentType.pdf));
    });

    test('fromMimeOrUrl correctly identifies Image from mime', () {
      final type = DocumentType.fromMimeOrUrl(mimeType: 'image/jpeg');
      expect(type, equals(DocumentType.image));
    });

    test('fromMimeOrUrl correctly identifies Image from url', () {
      final type = DocumentType.fromMimeOrUrl(url: 'https://example.com/photo.png');
      expect(type, equals(DocumentType.image));
    });

    test('fromMimeOrUrl returns other when unknown', () {
      final type = DocumentType.fromMimeOrUrl(url: 'https://example.com/doc.docx');
      expect(type, equals(DocumentType.other));
    });
  });

  group('DocumentItemEntity', () {
    test('creates entity and infers type via factory', () {
      final entity = DocumentItemEntity.inferred(
        id: '1',
        name: 'Lease Agreement',
        url: 'https://example.com/lease.pdf',
        fileSize: '2.4 MB',
        createdAt: '2026-08-17',
      );

      expect(entity.id, equals('1'));
      expect(entity.name, equals('Lease Agreement'));
      expect(entity.type, equals(DocumentType.pdf));
      expect(entity.props, contains('Lease Agreement'));
    });

    test('respects explicit type when provided in const constructor', () {
      const entity = DocumentItemEntity(
        id: '2',
        name: 'Custom Doc',
        url: 'https://example.com/custom',
        type: DocumentType.image,
      );

      expect(entity.type, equals(DocumentType.image));
    });
  });
}

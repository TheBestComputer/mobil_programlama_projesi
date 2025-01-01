//tedarik_detay_test.dart
import 'package:denemeeeeeee/screens/tedarik_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../helper/firebase_mock_helper.dart';

class MockDocumentSnapshot extends Mock implements DocumentSnapshot {
  @override
  Map<String, dynamic> data() => {
    'description': 'Test Description',
    'sector': 'Test Sector',
    'fileUrl': 'https://example.com/file.pdf',
    'imageUrl': 'https://example.com/image.jpg',
  };

  @override
  bool get exists => true;
}

void main() {
  setupFirebaseAuthMocks();

  testWidgets('TedarikDetailScreen displays tedarik information correctly',
          (WidgetTester tester) async {
        final mockDocumentSnapshot = MockDocumentSnapshot();

        await tester.pumpWidget(
          MaterialApp(
            home: TedarikDetailScreen(tedarikId: 'test-id'),
          ),
        );

        await tester.pump();

        // Verify UI elements are present
        expect(find.text('Tedarik Detayı'), findsOneWidget);
        expect(find.text('Tedarik Detaylarını Güncelle'), findsOneWidget);
        expect(find.byType(TextField), findsNWidgets(3));
      });

  testWidgets('TedarikDetailScreen handles update correctly',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: TedarikDetailScreen(tedarikId: 'test-id'),
          ),
        );

        // Enter new values
        await tester.enterText(
            find.widgetWithText(TextField, 'Açıklama'), 'Updated Description');
        await tester.enterText(
            find.widgetWithText(TextField, 'Sektör'), 'Updated Sector');

        // Tap update button
        await tester.tap(find.text('Güncelle'));
        await tester.pump();

        // Verify success message
        expect(find.text('Tedarik başarıyla güncellendi!'), findsOneWidget);
      });
}

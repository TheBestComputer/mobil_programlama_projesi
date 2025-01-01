
//tedariklerim_test.dart
import 'package:denemeeeeeee/screens/my_tedarikler_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../helper/firebase_mock_helper.dart';

class MockQuerySnapshot extends Mock implements QuerySnapshot {
  @override
  List<QueryDocumentSnapshot> get docs => [
    MockQueryDocumentSnapshot(),
  ];
}

class MockQueryDocumentSnapshot extends Mock implements QueryDocumentSnapshot {
  @override
  Map<String, dynamic> data() => {
    'description': 'Test Tedarik',
    'sector': 'Test Sector',
    'status': 'active',
  };

  @override
  String get id => 'test-id';
}

void main() {
  setupFirebaseAuthMocks();

  testWidgets('MyTedariklerScreen displays tedarik list correctly',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: MyTedariklerScreen(),
          ),
        );

        await tester.pump();

        // Verify UI elements
        expect(find.text('Paylaştıklarım'), findsOneWidget);
        expect(find.byType(Card), findsWidgets);
        expect(find.text('Test Tedarik'), findsOneWidget);
        expect(find.text('Sektör: Test Sector'), findsOneWidget);
        expect(find.text('Durum: active'), findsOneWidget);
      });

  testWidgets('MyTedariklerScreen handles empty state correctly',
          (WidgetTester tester) async {
        when(MockQuerySnapshot().docs).thenReturn([]);

        await tester.pumpWidget(
          MaterialApp(
            home: MyTedariklerScreen(),
          ),
        );

        await tester.pump();

        expect(find.text('Henüz tedarik paylaşmadınız.'), findsOneWidget);
      });

  testWidgets('MyTedariklerScreen navigates to detail screen on tap',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: MyTedariklerScreen(),
          ),
        );

        await tester.pump();

        // Tap on the first tedarik
        await tester.tap(find.byType(ListTile).first);
        await tester.pumpAndSettle();

        // Verify navigation to detail screen
        expect(find.text('Tedarik Detayı'), findsOneWidget);
      });
}
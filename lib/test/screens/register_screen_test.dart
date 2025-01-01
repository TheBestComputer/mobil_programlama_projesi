
//kayıtol_test.dart
import 'package:denemeeeeeee/test/helper/firebase_mock_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:denemeeeeeee/screens/register_screen.dart';
import 'package:denemeeeeeee/services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MockFirestoreService extends Mock implements FirestoreService {}

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

void main() {
  late MockFirestoreService mockFirestoreService;
  late MockFirebaseAuth mockFirebaseAuth;

  setUp(() {
    setupFirebaseAuthMocks(); // Firebase Mock'ları başlatma
    mockFirestoreService = MockFirestoreService();
    mockFirebaseAuth = MockFirebaseAuth();
  });

  Future<void> pumpRegisterScreen(WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: const RegisterScreen()));
  }

  testWidgets('RegisterScreen Widget renders all widgets properly', (WidgetTester tester) async {
    await pumpRegisterScreen(tester);

    expect(find.text('Kullanıcı Adı'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Şifre'), findsOneWidget);
    expect(find.text('Kayıt Ol'), findsOneWidget);
  });

  testWidgets('RegisterScreen registers user successfully', (WidgetTester tester) async {
    await pumpRegisterScreen(tester);

    when(mockFirebaseAuth.createUserWithEmailAndPassword(
      email: anyNamed('email'),
      password: anyNamed('password'),
    )).thenAnswer((_) async => MockUserCredential());

    await tester.enterText(find.byType(TextField).at(0), 'testuser');
    await tester.enterText(find.byType(TextField).at(1), 'test@example.com');
    await tester.enterText(find.byType(TextField).at(2), 'password123');

    await tester.tap(find.text('Kayıt Ol'));
    await tester.pump();

    verify(mockFirebaseAuth.createUserWithEmailAndPassword(
      email: 'test@example.com',
      password: 'password123',
    )).called(1);
  });

  testWidgets('Displays error message on registration failure', (WidgetTester tester) async {
    await pumpRegisterScreen(tester);

    when(mockFirebaseAuth.createUserWithEmailAndPassword(
      email: anyNamed('email'),
      password: anyNamed('password'),
    )).thenThrow(FirebaseAuthException(code: 'email-already-in-use'));

    await tester.enterText(find.byType(TextField).at(0), 'testuser');
    await tester.enterText(find.byType(TextField).at(1), 'test@example.com');
    await tester.enterText(find.byType(TextField).at(2), 'password123');

    await tester.tap(find.text('Kayıt Ol'));
    await tester.pump();

    expect(find.textContaining('Kayıt sırasında bir hata oluştu'), findsOneWidget);
  });
}

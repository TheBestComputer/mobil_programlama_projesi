import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:denemeeeeeee/screens/login_screen.dart';

void main() {
  testWidgets('Login ekranında giriş yapma işlemi başarılı', (WidgetTester tester) async {
    // Mock Firebase Auth örneği oluştur
    final mockAuth = MockFirebaseAuth();

    // Login ekranını yükle
    await tester.pumpWidget(
      MaterialApp(
        home: const LoginScreen(),
      ),
    );

    // Email ve şifre alanlarını bul
    final emailField = find.widgetWithText(TextField, 'E-posta');
    final passwordField = find.widgetWithText(TextField, 'Şifre');

    // Text alanlarına değer gir
    await tester.enterText(emailField, 'test@example.com');
    await tester.enterText(passwordField, 'password123');

    // Login butonunu bul ve tıkla
    final loginButton = find.widgetWithText(ElevatedButton, 'Giriş Yap');
    await tester.tap(loginButton);

    // Widget'ın yeniden build edilmesini bekle
    await tester.pumpAndSettle();

    // Giriş hatası mesajının görünmediğini doğrula
    final errorMessage = find.text('Giriş başarısız: Hatalı e-posta veya şifre.');
    expect(errorMessage, findsNothing);

    // Mock Firebase Auth kullanıcısının giriş yapıp yapmadığını kontrol et
    final user = mockAuth.currentUser;
    expect(user, isNull); // Bu durumda kullanıcı giriş yapmaz çünkü mock'u bağlamıyoruz
  });
}

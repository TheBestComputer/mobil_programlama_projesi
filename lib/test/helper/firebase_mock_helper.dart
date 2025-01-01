import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

// Mock FirebaseAuth
class MockFirebaseAuth extends Mock implements FirebaseAuth {}

// Mock UserCredential
class MockUserCredential extends Mock implements UserCredential {
  @override
  User? get user => MockUser();
}

// Mock User
class MockUser extends Mock implements User {
  @override
  String get uid => 'test_uid';

  @override
  String? get email => 'test@example.com';

  @override
  String? get displayName => 'Test User';
}

class MockFirebaseAppPlatform extends Fake implements FirebaseAppPlatform {
  @override
  String get name => '[DEFAULT]';

  @override
  FirebaseOptions get options => const FirebaseOptions(
    apiKey: 'fake-api-key',
    appId: 'fake-app-id',
    messagingSenderId: 'fake-sender-id',
    projectId: 'fake-project-id',
  );
}

class MockFirebasePlatform extends FirebasePlatform {
  MockFirebasePlatform() : super();

  @override
  Future<FirebaseAppPlatform> initializeApp({
    String? name,
    FirebaseOptions? options,
  }) async {
    return MockFirebaseAppPlatform();
  }

  @override
  FirebaseAppPlatform app([String name = defaultFirebaseAppName]) {
    return MockFirebaseAppPlatform();
  }

  @override
  List<FirebaseAppPlatform> get apps {
    return [MockFirebaseAppPlatform()];
  }
}

void setupFirebaseAuthMocks() {
  TestWidgetsFlutterBinding.ensureInitialized();
  FirebasePlatform.instance = MockFirebasePlatform();
}
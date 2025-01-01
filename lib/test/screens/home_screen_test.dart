import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';

class MockFirebaseAppPlatform extends FirebaseAppPlatform {
  MockFirebaseAppPlatform()
      : super(
    '[DEFAULT]',
    const FirebaseOptions(
      apiKey: 'fake-api-key',
      appId: 'fake-app-id',
      messagingSenderId: 'fake-sender-id',
      projectId: 'fake-project-id',
    ),
  );

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

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Setup mock Firebase
  setupFirebaseAuthMocks();

  test('MockFirebasePlatform initializes correctly', () async {
    await Firebase.initializeApp();
    final app = Firebase.app();

    // Check app name and options
    expect(app.name, '[DEFAULT]');
    expect(app.options.apiKey, 'fake-api-key');
    expect(app.options.projectId, 'fake-project-id');
  });
}

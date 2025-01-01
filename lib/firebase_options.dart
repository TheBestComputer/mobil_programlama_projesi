
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;


class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAnK9c294GL9MiaRC7RbdvzvIlPBQtIUjs',
    appId: '1:1040543059718:web:8b3fbf54aefc7d0ffad887',
    messagingSenderId: '1040543059718',
    projectId: 'deneme-mahmut',
    authDomain: 'deneme-mahmut.firebaseapp.com',
    storageBucket: 'deneme-mahmut.firebasestorage.app',
    measurementId: 'G-KJ3TVQMHM7',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAOFrtn7D6_3BcrT7x4r_pMCgMtN0SVfQk',
    appId: '1:1040543059718:android:c20ae2c707470d32fad887',
    messagingSenderId: '1040543059718',
    projectId: 'deneme-mahmut',
    storageBucket: 'deneme-mahmut.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBBCVyYKdhPEYpDsmQof3Q6ufTp9PSRVXw',
    appId: '1:1040543059718:ios:28f25f51cd9048adfad887',
    messagingSenderId: '1040543059718',
    projectId: 'deneme-mahmut',
    storageBucket: 'deneme-mahmut.firebasestorage.app',
    iosBundleId: 'com.example.denemeeeeeee',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBBCVyYKdhPEYpDsmQof3Q6ufTp9PSRVXw',
    appId: '1:1040543059718:ios:28f25f51cd9048adfad887',
    messagingSenderId: '1040543059718',
    projectId: 'deneme-mahmut',
    storageBucket: 'deneme-mahmut.firebasestorage.app',
    iosBundleId: 'com.example.denemeeeeeee',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAnK9c294GL9MiaRC7RbdvzvIlPBQtIUjs',
    appId: '1:1040543059718:web:4651abb292da82a1fad887',
    messagingSenderId: '1040543059718',
    projectId: 'deneme-mahmut',
    authDomain: 'deneme-mahmut.firebaseapp.com',
    storageBucket: 'deneme-mahmut.firebasestorage.app',
    measurementId: 'G-XCBBBXEX17',
  );

}

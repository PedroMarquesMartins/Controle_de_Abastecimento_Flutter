// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
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
    apiKey: 'AIzaSyA1fTBgPWVCYangGrurV-aIT926RzihcLc',
    appId: '1:178807260404:web:838109a5a85bc769dfcaa1',
    messagingSenderId: '178807260404',
    projectId: 'p2-projeto-59cd5',
    authDomain: 'p2-projeto-59cd5.firebaseapp.com',
    storageBucket: 'p2-projeto-59cd5.firebasestorage.app',
    measurementId: 'G-VZ9BZ06Q1W',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBhiiuTIK6OUQ-T__PD7OrgcawyLcUUQEU',
    appId: '1:178807260404:android:be4cdc44c1052c6adfcaa1',
    messagingSenderId: '178807260404',
    projectId: 'p2-projeto-59cd5',
    storageBucket: 'p2-projeto-59cd5.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB9VhzNKueq1PnOu7IQIqgdp5udv0EqS_c',
    appId: '1:178807260404:ios:b370f6e2e8b2e71cdfcaa1',
    messagingSenderId: '178807260404',
    projectId: 'p2-projeto-59cd5',
    storageBucket: 'p2-projeto-59cd5.firebasestorage.app',
    iosClientId: '178807260404-svkpnu3ddvcd87vujh3udjno6dt8lqt4.apps.googleusercontent.com',
    iosBundleId: 'br.unigran.p2Projeto',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB9VhzNKueq1PnOu7IQIqgdp5udv0EqS_c',
    appId: '1:178807260404:ios:b370f6e2e8b2e71cdfcaa1',
    messagingSenderId: '178807260404',
    projectId: 'p2-projeto-59cd5',
    storageBucket: 'p2-projeto-59cd5.firebasestorage.app',
    iosClientId: '178807260404-svkpnu3ddvcd87vujh3udjno6dt8lqt4.apps.googleusercontent.com',
    iosBundleId: 'br.unigran.p2Projeto',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyA1fTBgPWVCYangGrurV-aIT926RzihcLc',
    appId: '1:178807260404:web:bb5d8bb841ee680edfcaa1',
    messagingSenderId: '178807260404',
    projectId: 'p2-projeto-59cd5',
    authDomain: 'p2-projeto-59cd5.firebaseapp.com',
    storageBucket: 'p2-projeto-59cd5.firebasestorage.app',
    measurementId: 'G-LTYQ3V3GEE',
  );
}

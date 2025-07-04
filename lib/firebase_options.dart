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
    apiKey: 'AIzaSyAjFKaIGTyvoJSVsVTE_-4W_nV0FcFPp3s',
    appId: '1:601844275628:web:51517680440790923b8209',
    messagingSenderId: '601844275628',
    projectId: 'flutter-project-9dfaf',
    authDomain: 'flutter-project-9dfaf.firebaseapp.com',
    storageBucket: 'flutter-project-9dfaf.firebasestorage.app',
    measurementId: 'G-H8WPH4YCZK',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBsrXwAQ1KmuC1uRLM5Z8-SBHUmlWUHJ3o',
    appId: '1:601844275628:android:601f26f1967a9b8b3b8209',
    messagingSenderId: '601844275628',
    projectId: 'flutter-project-9dfaf',
    storageBucket: 'flutter-project-9dfaf.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD9YtiiDcR-TTmH1sdyKRjJjlkhQmgvpos',
    appId: '1:601844275628:ios:13fdfe4180992f843b8209',
    messagingSenderId: '601844275628',
    projectId: 'flutter-project-9dfaf',
    storageBucket: 'flutter-project-9dfaf.firebasestorage.app',
    iosBundleId: 'com.example.skillpath',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD9YtiiDcR-TTmH1sdyKRjJjlkhQmgvpos',
    appId: '1:601844275628:ios:13fdfe4180992f843b8209',
    messagingSenderId: '601844275628',
    projectId: 'flutter-project-9dfaf',
    storageBucket: 'flutter-project-9dfaf.firebasestorage.app',
    iosBundleId: 'com.example.skillpath',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAjFKaIGTyvoJSVsVTE_-4W_nV0FcFPp3s',
    appId: '1:601844275628:web:f0e864f321d02b433b8209',
    messagingSenderId: '601844275628',
    projectId: 'flutter-project-9dfaf',
    authDomain: 'flutter-project-9dfaf.firebaseapp.com',
    storageBucket: 'flutter-project-9dfaf.firebasestorage.app',
    measurementId: 'G-LTD51DQHTC',
  );
}

// Ejecutá: dart pub global activate flutterfire_cli && flutterfire configure
// para generar este archivo con los datos reales de tu proyecto Firebase.

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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions no está configurado para esta plataforma.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDcbtcieJACUOBcopXJHPEEfYdKMdxaPwE',
    appId: '1:438525704106:web:18894f8d59d3e1609a1dd3',
    messagingSenderId: '438525704106',
    projectId: 'reservas-citas-c2198',
    authDomain: 'reservas-citas-c2198.firebaseapp.com',
    storageBucket: 'reservas-citas-c2198.firebasestorage.app',
    measurementId: 'G-S4SWWGKGMG',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCdJTUTkPal00iBJKZa5ohXlvemxS3T4xw',
    appId: '1:438525704106:android:d0c8038a830ea76a9a1dd3',
    messagingSenderId: '438525704106',
    projectId: 'reservas-citas-c2198',
    storageBucket: 'reservas-citas-c2198.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCIlSKiUw6w0cN6Tlq2UodpjHrrsZealag',
    appId: '1:438525704106:ios:be669f9a47c4d8a69a1dd3',
    messagingSenderId: '438525704106',
    projectId: 'reservas-citas-c2198',
    storageBucket: 'reservas-citas-c2198.firebasestorage.app',
    iosBundleId: 'com.example.reservasCitas',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCIlSKiUw6w0cN6Tlq2UodpjHrrsZealag',
    appId: '1:438525704106:ios:be669f9a47c4d8a69a1dd3',
    messagingSenderId: '438525704106',
    projectId: 'reservas-citas-c2198',
    storageBucket: 'reservas-citas-c2198.firebasestorage.app',
    iosBundleId: 'com.example.reservasCitas',
  );

}
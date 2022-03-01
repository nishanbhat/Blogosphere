import 'package:flutter/services.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';

class LocalAuthApi {
  static final _auth = LocalAuthentication();

  static AndroidAuthMessages androidStrings = const AndroidAuthMessages(
    cancelButton: 'cancel',
    goToSettingsButton: 'setting',
    biometricNotRecognized: 'Not Recognized',
    biometricSuccess: 'authentication success',
  );

  static Future<bool> hasBiometrics() async {
    try {
      return await _auth.canCheckBiometrics;
    } on PlatformException {
      return false;
    }
  }

  static Future<bool> authenticate() async {
    final auth = await hasBiometrics();
    if (!auth) {
      return false;
    }
    try {
      return await _auth.authenticate(
          sensitiveTransaction: true,
          localizedReason: "Scan Your Biometrics",
          useErrorDialogs: true,
          androidAuthStrings: androidStrings,
          stickyAuth: true);
    } on PlatformException {
      return false;
    }
  }
}

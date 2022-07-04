import 'package:local_auth/local_auth.dart';

class BiometricsController {
  static final LocalAuthentication auth = LocalAuthentication();

  Future<bool> _getCanAuthenticateWithBiometrics() async {
    final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
    return canAuthenticateWithBiometrics;
  }

  Future<List<BiometricType>> _getAvailableBiometrics() async {
    if (await _getCanAuthenticateWithBiometrics()) {
      final List<BiometricType> availableBiometrics =
          await auth.getAvailableBiometrics();
      return availableBiometrics;
    } else
      return [];
  }

  Future<bool> isFingerprintAvailable() async {
    final availableBiometrics = await _getAvailableBiometrics();
    if (availableBiometrics.contains(BiometricType.fingerprint))
      return true;
    else
      return false;
  }

  Future<bool> isFaceIdAvailable() async {
    final availableBiometrics = await _getAvailableBiometrics();
    if (availableBiometrics.contains(BiometricType.face))
      return true;
    else
      return false;
  }

  Future<bool> authenticateWithBiometrics() async {
    final isFingerprint = await isFingerprintAvailable();
    final isFaceId = await isFaceIdAvailable();
    if (isFaceId || isFingerprint) {
      final bool didAuthenticate = await auth.authenticate(
          localizedReason: "Touch to process biometrics",
          options: const AuthenticationOptions(biometricOnly: true));
      return didAuthenticate;
    } else {
      return false;
    }
  }
}

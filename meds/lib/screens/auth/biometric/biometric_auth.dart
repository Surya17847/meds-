// import 'package:local_auth/local_auth.dart';
//
// class BiometricAuth {
//   final LocalAuthentication auth = LocalAuthentication();
//
//   // Method to handle biometric authentication
//   Future<bool> authenticateUser() async {
//     bool authenticated = false;
//     try {
//       authenticated = await auth.authenticate(
//         localizedReason: 'Please authenticate to access the app',
//         options: const AuthenticationOptions(
//           stickyAuth: true, // Keeps the authentication session alive
//         ),
//       );
//     } catch (e) {
//       print("Error during authentication: $e");
//     }
//     return authenticated;
//   }
//
//   // Method to check if biometrics are available
//   Future<bool> canAuthenticate() async {
//     return await auth.canCheckBiometrics;
//   }
// }

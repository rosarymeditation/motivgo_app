// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:sign_in_with_apple/sign_in_with_apple.dart';

// class AuthService {
//   final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
//   Stream<User?> authStateChanges() => _firebaseAuth.authStateChanges();
//   String getuserEmail()=> _firebaseAuth.currentUser?.email ??"User";
//   Future<UserCredential?> signInWithApple() async {
//     try {
//       final appleCredentials =
//           await SignInWithApple.getAppleIDCredential(scopes: [
//         AppleIDAuthorizationScopes.email,
//         AppleIDAuthorizationScopes.fullName,
//       ]);
//       final oAuthCredential = OAuthProvider("apple.com").credential(
//           idToken: appleCredentials.identityToken,
//           accessToken: appleCredentials.authorizationCode);
//       return await _firebaseAuth.signInWithCredential(oAuthCredential);
//     } catch (e) {
//       print(e);
//       print("Error during sign in with Apple");
//       return null;
//     }
//   }

//   Future<void> signOut() async {
//     await _firebaseAuth.signOut();
//   }

//   signInWithGoogle()async{
//     final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
//     final GoogleSignInAuthentication gAuth = await gUser!.authentication;

//     final credential = GoogleAuthProvider.credential(
//       accessToken: gAuth.accessToken,
//       idToken: gAuth.idToken
//     );
//     return await _firebaseAuth.signInWithCredential(credential);
//   }
// }

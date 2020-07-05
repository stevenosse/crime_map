import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UsersService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<FirebaseUser> loginUser() async {
    try {
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final AuthCredential credential = GoogleAuthProvider.getCredential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        final FirebaseUser user =
            (await _auth.signInWithCredential(credential)).user;
        return user;
      } else {
        throw new Exception(
            "Sorry, we were unable to log you in. Please try again.");
      }
    } catch (error) {
      print(error);
      switch (error.code) {
        case "ERROR_INVALID_EMAIL":
          throw new Exception("Your email address appears to be malformed.");
          break;
        case "ERROR_WRONG_PASSWORD":
          throw new Exception("Your password is wrong.");
          break;
        case "ERROR_USER_NOT_FOUND":
          throw new Exception("User with this email doesn't exist.");
          break;
        case "ERROR_USER_DISABLED":
          throw new Exception("User with this email has been disabled.");
          break;
        case "ERROR_TOO_MANY_REQUESTS":
          throw new Exception("Too many requests. Try again later.");
          break;
        case "ERROR_OPERATION_NOT_ALLOWED":
          throw new Exception(
              "Signing in with Email and Password is not enabled.");
          break;
        default:
          throw new Exception("Sorry, we were unable to log you in");
      }
    }
  }
}

final UsersService usersService = UsersService();

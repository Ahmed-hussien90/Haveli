import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

import '../utils/util.dart';
import '../view/screens/login.dart';

class AuthenticationController extends GetxController {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('Signed in user: ${userCredential.user}');
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print('Error signing in: ');
      return null;
    }
  }

  Future<User?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    var userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    addUser(userCredential.user!.uid, userCredential.user!.displayName!,
        userCredential.user!.email!, "o");
    return userCredential.user;
  }

  Future<User?> signUpWithEmailAndPassword(
      String username, String email, String password) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await userCredential.user?.updateDisplayName(username);
      print('Signed in user: ${userCredential.user}');
      await addUser(userCredential.user!.uid, username, email, password);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print('Error signing in: ');
      return null;
    }
  }

  Future<void> logOut() async {
    await auth.signOut();
    Get.off(const LoginScreen());
    Fluttertoast.showToast(msg: "logged out".tr);
    update();
  }

  addUser(String uid, String username, String email, String password) async {
    await FirebaseDatabase.instance
        .ref()
        .child("users")
        .child(uid)
        .set({"username": username, "email": email, "password": password});
  }

  Future<void> updateUser(XFile? image, String name, String email,
      String password, String newPassword) async {
    var currentUser = auth.currentUser;
    var currentPassword = (await FirebaseDatabase.instance
            .ref()
            .child("users")
            .child(currentUser!.uid)
            .child("password")
            .get())
        .value as String;
    if (password != currentPassword) {
      Fluttertoast.showToast(msg: "Password not Correct".tr);
      return;
    }

    if (image != null) {
      String imageUrl = await uploadImage(await image.readAsBytes(),
          "images/users/${currentUser.displayName}", image.name.trim());
      print(imageUrl);
      await currentUser.updatePhotoURL(imageUrl);
    }
    await currentUser.updateDisplayName(name);
    await currentUser
        .updatePassword(newPassword.isNotEmpty ? newPassword : password);
    await currentUser.updateEmail(email);
    await addUser(currentUser.uid, name, email, newPassword.isNotEmpty ? newPassword : password);
    var credential = EmailAuthProvider.credential(
        email: email,
        password: newPassword.isNotEmpty ? newPassword : password);
   await currentUser.reauthenticateWithCredential(credential);
    update();
  }
}

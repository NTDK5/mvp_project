import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign up with email and password
  Future<User?> signUpWithEmailAndPassword(
      String email, String password, String username) async {
    try {
      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      String uuid = userCredential.user!.uid;
      await FirebaseFirestore.instance.collection('users').doc(uuid).set({
        'username': username,
        'email': email,
        // You can add more user details here if needed
      });
      return userCredential.user;
    } catch (e) {
      print('Sign up failed: $e');
      throw e;
    }
  }

  // Sign in with email and password
  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } catch (e) {
      print('Sign in failed: $e');
      throw e;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Get the current user
  Future<User?> getCurrentUser() async {
    return _auth.currentUser;
  }

  // Get the current user's document
  Future<DocumentSnapshot?> getCurrentUserDocument() async {
    final User? user = await getCurrentUser();
    if (user != null) {
      return _firestore.collection('users').doc(user.uid).get();
    }
    return null;
  }

  // Get user data
  Future<Map<String, dynamic>?> getUserData() async {
    final User? user = await getCurrentUser();
    if (user != null) {
      DocumentSnapshot userDataSnapshot =
          await _firestore.collection('users').doc(user.uid).get();

      if (userDataSnapshot.exists) {
        return userDataSnapshot.data() as Map<String, dynamic>;
      }
    }
    return null;
  }

  // Update user data
  Future<void> updateUserData(Map<String, dynamic> userData) async {
    final User? user = await getCurrentUser();
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).set(userData);
    }
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../runtime_models/user/private_profile.dart';
import '../runtime_models/user/public_profile.dart';
import '../runtime_models/user/user_data.dart';
import '../services/user_data_repository.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Stream<User?> get userAuthState => _firebaseAuth.authStateChanges();

  // ignore: non_constant_identifier_names
  Future<bool> isValid_Email(String email) async {
    try {
      List<String> signInMethods = await _firebaseAuth.fetchSignInMethodsForEmail(email);
      return signInMethods.isEmpty;
    } catch (e) {
      return false;
    }
  }

  // ignore: non_constant_identifier_names
  Future<void> createUserWith_EmailAndPassword({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      User? user =
          (await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password))
              .user;

      if (user == null) return;

      //Construct new user
      await UserDataRepository.user(uid: user.uid).pushUserData(UserData(
        uid: user.uid,
        publicProfile: PublicProfile(uid: user.uid, name: username),
        privateProfile: PrivateProfile(themeData: ThemeData.light()),
        registeredFriends: List.empty(),
        nonRegisteredFriends: List.empty(),
      ));
    } catch (e) {
      return;
    }
  }

  // ignore: non_constant_identifier_names
  Future signInWith_EmailAndPassword(String email, String password) async {
    try {
      User? user =
          (await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password)).user;

      if (user == null) return null;

      //return UserDataRepository(uid: user.uid).currentUserData;
    } catch (e) {
      //print(e.toString());
      //return null;
    }
  }

  Future signOut() {
    try {
      return _firebaseAuth.signOut();
    } catch (e) {
      throw Exception(e);
    }
  }
}
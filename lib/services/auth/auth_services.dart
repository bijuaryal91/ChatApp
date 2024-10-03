// ignore_for_file: unused_local_variable, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:samparka/services/auth/login_or_register.dart';
import 'package:samparka/pages/index_page.dart';

class AuthServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  Future<void> signin({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      // _firestore.collection("Users").doc(userCredential.user!.uid).set(
      //   {
      //     'uid': userCredential.user!.uid,
      //     'email': email,
      //     'fname': fname,
      //     'lname': lname,
      //   },
      // );
      await Future.delayed(const Duration(seconds: 1));
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => Indexpage()));
    } on FirebaseAuthException catch (e) {
      String message = '';
      switch (e.code) {
        case 'invalid-credential':
          message = 'Username or password is incorrect!';
          break;
        case 'network-request-failed':
          message = 'You are not connected to internet!';
          break;
        case 'invalid-email':
          message = 'The email address is not valid.';
          break;
        case 'user-disabled':
          message = 'User account has been disabled.';
          break;
        case 'channel-error':
          message = 'All Fields are required!';
          break;
        default:
          message = 'An error occurred: ${e.code}';
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.red,
      ));
    } catch (e) {
      // Display the actual error message in case of unexpected exceptions
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'An unexpected error occurred: $e',
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.red,
      ));
    }
  }

  Future<void> signup({
    required String email,
    required String password,
    required BuildContext context,
    required String firstName,
    required String lastName,
  }) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      _firestore.collection("Users").doc(userCredential.user!.uid).set(
        {
          'uid': userCredential.user!.uid,
          'email': email,
          'fname': firstName,
          'lname': lastName,
        },
      );
      await Future.delayed(const Duration(seconds: 1));
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => Indexpage()));
    } on FirebaseAuthException catch (e) {
      String message = '';
      switch (e.code) {
        case 'channel-error':
          message = 'All Fields are required!';
          break;
        case 'network-request-failed':
          message = 'You are not connected to internet!';
          break;
        case 'invalid-email':
          message = 'The email address is not valid.';
          break;
        case 'weak-password':
          message = 'Your Password is Very Weak!';
          break;
        case 'email-already-in-use':
          message = "User is already registered!";
          break;
        default:
          message = 'An error occurred: ${e.code}';
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.red,
      ));
    } catch (e) {
      // Display the actual error message in case of unexpected exceptions
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'An unexpected error occurred: $e',
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.red,
      ));
    }
  }

  Future<void> signout({required BuildContext context}) async {
    await FirebaseAuth.instance.signOut();
    await Future.delayed(const Duration(seconds: 1));
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => const LoginOrRegister()));
  }
}

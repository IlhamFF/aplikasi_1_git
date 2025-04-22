// lib/utils/firebase_diagnostics.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants/collection_constants.dart';

class FirebaseDiagnosticsPage extends StatefulWidget {
  @override
  _FirebaseDiagnosticsPageState createState() =>
      _FirebaseDiagnosticsPageState();
}

class _FirebaseDiagnosticsPageState extends State<FirebaseDiagnosticsPage> {
  String _authStatus = 'Checking...';
  String _firestoreStatus = 'Checking...';
  String _connectivityStatus = 'Checking...';
  String _rulesStatus = 'Checking...';

  @override
  void initState() {
    super.initState();
    _checkAllServices();
  }

  Future<void> _checkAllServices() async {
    await _checkAuthStatus();
    await _checkFirestoreStatus();
    await _checkConnectivity();
    await _checkFirestoreRules();
  }

  Future<void> _checkAuthStatus() async {
    try {
      final auth = FirebaseAuth.instance;
      final user = auth.currentUser;

      setState(() {
        _authStatus =
            user != null
                ? 'Authenticated as: ${user.email}'
                : 'Not authenticated';
      });
    } catch (e) {
      setState(() {
        _authStatus = 'Error: $e';
      });
    }
  }

  Future<void> _checkFirestoreStatus() async {
    try {
      final firestore = FirebaseFirestore.instance;
      await firestore.collection(Collections.users).limit(1).get();

      setState(() {
        _firestoreStatus = 'Connected successfully';
      });
    } catch (e) {
      setState(() {
        _firestoreStatus = 'Error: $e';
      });
    }
  }

  Future<void> _checkConnectivity() async {
    try {
      final result = await InternetAddress.lookup('google.com');

      setState(() {
        _connectivityStatus =
            result.isNotEmpty && result[0].rawAddress.isNotEmpty
                ? 'Connected to internet'
                : 'No internet connection';
      });
    } on SocketException catch (_) {
      setState(() {
        _connectivityStatus = 'No internet connection';
      });
    }
  }

  Future<void> _checkFirestoreRules() async {
    try {
      // Coba menulis ke koleksi test untuk memeriksa aturan
      final firestore = FirebaseFirestore.instance;

      // Coba membaca koleksi users
      try {
        await firestore.collection(Collections.users).limit(1).get();
        setState(() {
          _rulesStatus += '\n- Read users: Allowed';
        });
      } catch (e) {
        setState(() {
          _rulesStatus +=
              '\n- Read users: Denied (${e.toString().substring(0, 50)}...)';
        });
      }

      // Coba menulis ke koleksi test
      try {
        final testDoc = firestore.collection('test').doc('test_permissions');
        await testDoc.set({
          'test': 'value',
          'timestamp': FieldValue.serverTimestamp(),
        });
        await testDoc.delete();
        setState(() {
          _rulesStatus += '\n- Write test: Allowed';
        });
      } catch (e) {
        setState(() {
          _rulesStatus +=
              '\n- Write test: Denied (${e.toString().substring(0, 50)}...)';
        });
      }
    } catch (e) {
      setState(() {
        _rulesStatus = 'Error checking rules: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Firebase Diagnostics')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Authentication Status:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(_authStatus),
            SizedBox(height: 16),

            Text(
              'Firestore Status:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(_firestoreStatus),
            SizedBox(height: 16),

            Text(
              'Connectivity Status:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(_connectivityStatus),
            SizedBox(height: 16),

            Text(
              'Firestore Rules Status:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(_rulesStatus),
            SizedBox(height: 32),

            ElevatedButton(
              onPressed: _checkAllServices,
              child: Text('Refresh Status'),
            ),
          ],
        ),
      ),
    );
  }
}

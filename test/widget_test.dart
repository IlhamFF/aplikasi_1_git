import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aplikasi_1/main.dart';

void main() {
  testWidgets('Login page displays correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp()); // Hapus 'const' dari sini

    // Verifikasi bahwa halaman login ditampilkan.
    expect(find.text('Login'), findsOneWidget); // Cek judul AppBar
    expect(
      find.byType(TextField),
      findsNWidgets(2),
    ); // Cek ada 2 TextField (email & password)
    expect(
      find.widgetWithText(ElevatedButton, 'Login'),
      findsOneWidget,
    ); // Cek tombol login
  });

  testWidgets('Login page text fields are functional', (
    WidgetTester tester,
  ) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Masukkan teks ke dalam TextField email dan password.
    await tester.enterText(
      find.byType(TextField).at(0),
      'test@example.com',
    ); // Email field
    await tester.enterText(
      find.byType(TextField).at(1),
      'password123',
    ); // Password field

    // Verifikasi bahwa teks sudah dimasukkan.
    expect(find.text('test@example.com'), findsOneWidget);
    expect(find.text('password123'), findsOneWidget);
  });
}

# Membuat folder ui dan subfoldernya
New-Item -Path "lib/ui/components" -ItemType Directory -Force
New-Item -Path "lib/ui/styles" -ItemType Directory -Force
New-Item -Path "lib/ui/theme" -ItemType Directory -Force

# Membuat file di components/
New-Item -Path "lib/ui/components/custom_button.dart" -ItemType File -Force
New-Item -Path "lib/ui/components/custom_card.dart" -ItemType File -Force
New-Item -Path "lib/ui/components/custom_list_tile.dart" -ItemType File -Force
New-Item -Path "lib/ui/components/custom_text_field.dart" -ItemType File -Force
New-Item -Path "lib/ui/components/custom_app_bar.dart" -ItemType File -Force

# Membuat file di styles/
New-Item -Path "lib/ui/styles/app_styles.dart" -ItemType File -Force

# Membuat file di theme/
New-Item -Path "lib/ui/theme/app_theme.dart" -ItemType File -Force

# Menambahkan konten minimal ke setiap file Dart
Set-Content -Path "lib/ui/components/custom_button.dart" -Value "// Custom Button Widget`nimport 'package:flutter/material.dart';`n`nclass CustomButton extends StatelessWidget {`n  const CustomButton({super.key});`n`n  @override`n  Widget build(BuildContext context) {`n    return Container();`n  }`n}"
Set-Content -Path "lib/ui/components/custom_card.dart" -Value "// Custom Card Widget`nimport 'package:flutter/material.dart';`n`nclass CustomCard extends StatelessWidget {`n  const CustomCard({super.key});`n`n  @override`n  Widget build(BuildContext context) {`n    return Container();`n  }`n}"
Set-Content -Path "lib/ui/components/custom_list_tile.dart" -Value "// Custom List Tile Widget`nimport 'package:flutter/material.dart';`n`nclass CustomListTile extends StatelessWidget {`n  const CustomListTile({super.key});`n`n  @override`n  Widget build(BuildContext context) {`n    return Container();`n  }`n}"
Set-Content -Path "lib/ui/components/custom_text_field.dart" -Value "// Custom Text Field Widget`nimport 'package:flutter/material.dart';`n`nclass CustomTextField extends StatelessWidget {`n  const CustomTextField({super.key});`n`n  @override`n  Widget build(BuildContext context) {`n    return Container();`n  }`n}"
Set-Content -Path "lib/ui/components/custom_app_bar.dart" -Value "// Custom App Bar Widget`nimport 'package:flutter/material.dart';`n`nclass CustomAppBar extends StatelessWidget implements PreferredSizeWidget {`n  const CustomAppBar({super.key});`n`n  @override`n  Widget build(BuildContext context) {`n    return AppBar();`n  }`n`n  @override`n  Size get preferredSize => const Size.fromHeight(kToolbarHeight);`n}"
Set-Content -Path "lib/ui/styles/app_styles.dart" -Value "// App Styles Constants`nimport 'package:flutter/material.dart';`n`nclass AppStyles {`n  static const Color primaryColor = Colors.blue;`n}"
Set-Content -Path "lib/ui/theme/app_theme.dart" -Value "// App Theme Configuration`nimport 'package:flutter/material.dart';`n`nclass AppTheme {`n  static ThemeData get themeData => ThemeData(`n        primarySwatch: Colors.blue,`n      );`n}"

Write-Host "Successfully generated UI folders and files!"
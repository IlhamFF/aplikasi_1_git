import 'package:flutter/material.dart';
import '../components/sidebar.dart';
import '../components/custom_app_bar.dart';

class SettingsLayout extends StatelessWidget {
  final Widget child;
  final List<SettingsCategory> categories;
  final String selectedCategory;
  final Function(String) onCategorySelected;

  const SettingsLayout({
    Key? key,
    required this.child,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isLargeScreen = screenWidth > 1000;

    return Scaffold(
      appBar: CustomAppBar(title: 'Pengaturan', showMenuButton: !isLargeScreen),
      drawer: !isLargeScreen ? Sidebar() : null,
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sidebar untuk layar besar
            if (isLargeScreen) Sidebar(),

            // Panel kategori pengaturan
            Container(
              width: isLargeScreen ? 250 : 200,
              height: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  right: BorderSide(color: Colors.grey.shade200, width: 1),
                ),
              ),
              child: ListView(
                padding: EdgeInsets.zero,
                children:
                    categories.map((category) {
                      return ListTile(
                        leading: Icon(category.icon),
                        title: Text(category.name),
                        selected: category.id == selectedCategory,
                        selectedTileColor: Theme.of(
                          context,
                        ).primaryColor.withOpacity(0.1),
                        selectedColor: Theme.of(context).primaryColor,
                        onTap: () => onCategorySelected(category.id),
                      );
                    }).toList(),
              ),
            ),

            // Konten pengaturan yang dipilih
            Expanded(
              child: Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: child,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsCategory {
  final String id;
  final String name;
  final IconData icon;

  SettingsCategory({required this.id, required this.name, required this.icon});
}

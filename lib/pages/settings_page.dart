import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:samparka/provider/theme_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: themeProvider.isDarkTheme ? Colors.black : Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: themeProvider.isDarkTheme
                ? [Colors.black, Colors.grey[850]!]
                : [Colors.white, Colors.blue[100]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              // Dark Theme Toggle
              ListTile(
                leading: Icon(
                  Icons.dark_mode,
                  color:
                      themeProvider.isDarkTheme ? Colors.white : Colors.black,
                ),
                title: Text(
                  'Dark Theme',
                  style: TextStyle(
                    fontSize: 18,
                    color:
                        themeProvider.isDarkTheme ? Colors.white : Colors.black,
                  ),
                ),
                trailing: Switch(
                  value: themeProvider.isDarkTheme,
                  onChanged: (value) {
                    themeProvider.toggleTheme();
                  },
                  activeColor: Colors.blue,
                ),
              ),
              // Add more settings options as needed
              // Privacy Settings
              ListTile(
                leading: Icon(
                  Icons.privacy_tip,
                  color:
                      themeProvider.isDarkTheme ? Colors.white : Colors.black,
                ),
                title: Text(
                  'Privacy',
                  style: TextStyle(
                    fontSize: 18,
                    color:
                        themeProvider.isDarkTheme ? Colors.white : Colors.black,
                  ),
                ),
                onTap: () {
                  // Navigate to privacy settings
                },
              ),
              // About
              ListTile(
                leading: Icon(
                  Icons.info,
                  color:
                      themeProvider.isDarkTheme ? Colors.white : Colors.black,
                ),
                title: Text(
                  'About',
                  style: TextStyle(
                    fontSize: 18,
                    color:
                        themeProvider.isDarkTheme ? Colors.white : Colors.black,
                  ),
                ),
                onTap: () {
                  // Show about dialog or navigate to about page
                },
              ),
              // Help
              ListTile(
                leading: Icon(
                  Icons.help,
                  color:
                      themeProvider.isDarkTheme ? Colors.white : Colors.black,
                ),
                title: Text(
                  'Help',
                  style: TextStyle(
                    fontSize: 18,
                    color:
                        themeProvider.isDarkTheme ? Colors.white : Colors.black,
                  ),
                ),
                onTap: () {
                  // Navigate to help or FAQ page
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:samparka/components/button.dart';
import 'dart:io';

import 'package:samparka/components/textfield.dart';
import 'package:samparka/provider/theme_provider.dart'; // Import the dart:io package

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  String firstName = '';
  String lastName = '';
  String password = '';
  XFile? _profileImage;

  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();
  TextEditingController pwController = TextEditingController();

  // Function to handle profile image picking
  Future<void> _pickProfileImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _profileImage = image;
    });
  }

  // Function to handle saving changes
  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Save the updated information
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: themeProvider.isDarkTheme ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: themeProvider.isDarkTheme
            ? const Color.fromARGB(255, 41, 40, 40)
            : const Color.fromARGB(255, 8, 136, 255),
        foregroundColor: Colors.white,
        title: const Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Profile Picture Section
                GestureDetector(
                  onTap: _pickProfileImage,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: _profileImage != null
                        ? FileImage(
                            File(_profileImage!.path)) // Convert XFile? to File
                        : const AssetImage('assets/default_profile.jpg')
                            as ImageProvider,
                  ),
                ),
                const SizedBox(height: 20),

                // First Name Field
                MyField(
                    labelText: "First Name",
                    hintText: "",
                    obscure: false,
                    controller: fnameController),
                const SizedBox(height: 10),

                // Last Name Field
                MyField(
                    labelText: "Last Name",
                    hintText: "",
                    obscure: false,
                    controller: lnameController),

                const SizedBox(height: 10),

                // Password Field
                MyField(
                    labelText: "Password",
                    hintText: "",
                    obscure: true,
                    controller: pwController),

                const SizedBox(height: 20),

                // Save Button
                MyButton(text: "Save Changes", onPressed: _saveChanges),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

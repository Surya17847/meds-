import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:meds/utils/ui_helper/app_theme.dart';
import 'package:meds/widgets/snackbar.dart';
import 'package:meds/screens/auth/login/login_page.dart';
import 'package:country_picker/country_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final User? user = FirebaseAuth.instance.currentUser;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  String? photoUrl;
  bool isEditing = false;
  String countryCode = "+1"; // Default country code

  @override
  void initState() {
    super.initState();
    _loadProfileDataFromFirestore();
  }

  Future<void> _loadProfileDataFromFirestore() async {
    if (user != null) {
      final userRef = FirebaseFirestore.instance.collection('users').doc(user!.uid);
      final snapshot = await userRef.get();

      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        setState(() {
          nameController.text = data['name'] ?? '';
          emailController.text = data['email'] ?? '';
          phoneController.text = data['phone'] ?? '';
          photoUrl = data['photoUrl'] ?? user!.photoURL;
        });
      } else {
        await userRef.set({
          'email': user!.email,
          'name': user!.displayName ?? '',
          'photoUrl': user!.photoURL ?? '',
        });
      }
    }
  }

  Future<void> _pickAndUploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      try {
        final storageRef = FirebaseStorage.instance.ref().child('user_profiles/${user?.uid}/profile_picture.png');
        await storageRef.putFile(File(pickedFile.path));
        final downloadUrl = await storageRef.getDownloadURL();

        await FirebaseFirestore.instance.collection('users').doc(user?.uid).update({'photoUrl': downloadUrl});

        setState(() {
          photoUrl = downloadUrl;
        });
        showCustomSnackBar(context, 'Profile picture updated successfully');
      } catch (e) {
        showCustomSnackBar(context, 'Error uploading image: $e', isError: true);
      }
    }
  }

  Future<void> _updateProfile() async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(user?.uid).update({
        'name': nameController.text.trim(),
        'phone': '$countryCode ${phoneController.text.trim()}',
      });

      setState(() {
        isEditing = false;
      });
      showCustomSnackBar(context, 'Profile updated successfully');
    } catch (e) {
      showCustomSnackBar(context, 'Error updating profile: $e', isError: true);
    }
  }

  void _showCountryPicker() {
    showCountryPicker(
      context: context,
      onSelect: (Country country) {
        setState(() {
          countryCode = "+${country.phoneCode}";
        });
      },
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout', style: AppFonts.headline),
          content: Text('Are you sure you want to logout?', style: AppFonts.body),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel', style: AppFonts.button),
            ),
            TextButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
              },
              child: Text('Logout', style: AppFonts.button.copyWith(color: AppColors.errorColor)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile', style: AppFonts.heading.copyWith(color: AppColors.whiteColor)),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            GestureDetector(
              onTap: isEditing ? _pickAndUploadImage : null,
              child: CircleAvatar(
                radius: 60,
                backgroundImage: photoUrl != null ? NetworkImage(photoUrl!) : const AssetImage('assets/male_avatar.png') as ImageProvider,
                backgroundColor: AppColors.primaryColor,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: nameController,
              enabled: isEditing,
              decoration: InputDecoration(labelText: 'Name', labelStyle: AppFonts.body, border: OutlineInputBorder()),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: emailController,
              enabled: false,
              decoration: InputDecoration(labelText: 'Email', labelStyle: AppFonts.body, border: OutlineInputBorder()),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                GestureDetector(
                  onTap: _showCountryPicker,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                    decoration: BoxDecoration(border: Border.all(color: AppColors.primaryColor), borderRadius: BorderRadius.circular(5)),
                    child: Text(countryCode, style: AppFonts.body),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: phoneController,
                    enabled: isEditing,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(labelText: 'Phone Number', labelStyle: AppFonts.body, border: OutlineInputBorder()),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isEditing ? _updateProfile : () => setState(() => isEditing = true),
              child: Text(isEditing ? 'Update Profile' : 'Edit Profile', style: AppFonts.button),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryColor, foregroundColor: AppColors.whiteColor),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _showLogoutDialog,
              child: Text('Logout', style: AppFonts.button),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.errorColor, foregroundColor: AppColors.whiteColor),
            ),
          ],
        ),
      ),
    );
  }
}
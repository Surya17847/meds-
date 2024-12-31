import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:meds/utils/ui_helper/app_colors.dart';
import 'package:meds/utils/ui_helper/app_fonts.dart';
import 'package:meds/widgets/snackbar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:meds/screens/auth/login/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:country_picker/country_picker.dart';  // Add country picker package

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
  String countryCode = "+1"; // Default country code (e.g., for US)

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      photoUrl = prefs.getString('photoUrl') ?? user?.photoURL;
      nameController.text = prefs.getString('name') ?? user?.displayName ?? '';
      emailController.text = prefs.getString('email') ?? user?.email ?? '';
      phoneController.text = prefs.getString('phone') ?? '';
    });
  }

  Future<void> _pickAndUploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      try {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('user_profiles/${user?.uid}/profile_picture.png');
        await storageRef.putFile(File(pickedFile.path));

        final downloadUrl = await storageRef.getDownloadURL();
        final userRef = FirebaseFirestore.instance.collection('users').doc(user?.uid);
        await userRef.update({'photoUrl': downloadUrl});

        final prefs = await SharedPreferences.getInstance();
        prefs.setString('photoUrl', downloadUrl);

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
      final userRef = FirebaseFirestore.instance.collection('users').doc(user?.uid);

      await userRef.update({
        'name': nameController.text.trim(),
        'email': emailController.text.trim(),
        'phone': '$countryCode ${phoneController.text.trim()}',
      });

      final prefs = await SharedPreferences.getInstance();
      prefs.setString('name', nameController.text.trim());
      prefs.setString('email', emailController.text.trim());
      prefs.setString('phone', phoneController.text.trim());

      setState(() {
        isEditing = false;
      });

      showCustomSnackBar(context, 'Profile updated successfully');
    } catch (e) {
      showCustomSnackBar(context, 'Error updating profile: $e', isError: true);
    }
  }

  Future<void> _verifyPhoneNumber(String phoneNumber) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    await auth.verifyPhoneNumber(
      phoneNumber: '$countryCode$phoneNumber', // Include country code
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential);
        _savePhoneNumber(phoneNumber);
      },
      verificationFailed: (FirebaseAuthException e) {
        showCustomSnackBar(context, 'Verification failed: ${e.message}', isError: true);
      },
      codeSent: (String verificationId, int? resendToken) {
        _promptForOTP(verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  void _promptForOTP(String verificationId) {
    TextEditingController otpController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enter OTP'),
        content: TextField(controller: otpController),
        actions: [
          TextButton(
            onPressed: () async {
              final credential = PhoneAuthProvider.credential(
                verificationId: verificationId,
                smsCode: otpController.text.trim(),
              );
              try {
                await FirebaseAuth.instance.signInWithCredential(credential);
                _savePhoneNumber(phoneController.text.trim());
                Navigator.pop(context);
              } catch (e) {
                showCustomSnackBar(context, 'Invalid OTP', isError: true);
              }
            },
            child: const Text('Verify'),
          ),
        ],
      ),
    );
  }

  Future<void> _savePhoneNumber(String phoneNumber) async {
    final userRef = FirebaseFirestore.instance.collection('users').doc(user?.uid);
    await userRef.update({'phone': phoneNumber});

    final prefs = await SharedPreferences.getInstance();
    prefs.setString('phone', phoneNumber);

    setState(() {
      phoneController.text = phoneNumber;
    });
    showCustomSnackBar(context, 'Phone number verified and saved!');
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  void _showCountryPicker() {
    showCountryPicker(
      context: context,
      onSelect: (Country country) {
        setState(() {
          countryCode = country.flagEmoji;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile', style: AppFonts.heading),
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
                backgroundImage: photoUrl != null
                    ? NetworkImage(photoUrl!)
                    : const AssetImage('assets/male_avatar.png') as ImageProvider,
                backgroundColor: AppColors.primaryColor,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: nameController,
              enabled: isEditing,
              decoration: InputDecoration(
                labelText: 'Name',
                hintText: 'Enter your full name', // Hint text added
                labelStyle: AppFonts.body,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primaryColor),
                ),
              ),
              style: AppFonts.body,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: emailController,
              enabled: isEditing,
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'example@domain.com', // Hint text added
                labelStyle: AppFonts.body,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primaryColor),
                ),
              ),
              style: AppFonts.body,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                GestureDetector(
                  onTap: _showCountryPicker,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.primaryColor),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      countryCode,
                      style: AppFonts.body,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: phoneController,
                    enabled: isEditing,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      hintText: 'Enter your phone number',
                      labelStyle: AppFonts.body,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.primaryColor),
                      ),
                    ),
                    style: AppFonts.body,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (isEditing)
              ElevatedButton(
                onPressed: () {
                  _verifyPhoneNumber(phoneController.text.trim());
                },
                child: const Text('Verify Phone Number'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: AppColors.whiteColor,
                ),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isEditing ? _updateProfile : () {
                setState(() {
                  isEditing = true;
                });
              },
              child: Text(isEditing ? 'Update Profile' : 'Edit Profile'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: AppColors.whiteColor,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _showLogoutDialog,
              child: const Text('Logout'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondaryColor,
                foregroundColor: AppColors.whiteColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

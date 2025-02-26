import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloudinary_url_gen/cloudinary.dart';
import 'package:cloudinary_flutter/image/cld_image.dart';
import 'package:cloudinary_flutter/cloudinary_context.dart';
import 'package:meds/utils/.env';

var cloudinary = Cloudinary.fromStringUrl(CLOUDINARY_URL);
String url = cloudinary.image('sample.jpg').toString();

// String url = (cloudinary.image('sample.jpg')
//   ..transformation(Transformation()
//     ..resize(Resize.crop()
//       ..width(100)
//       ..height(150))))
//     .toString();
// /*
// class CloudinaryHelper {
//   final Cloudinary _cloudinary;
//
//   // Initialize Cloudinary instance
//   CloudinaryHelper(String cloudName, String apiKey, String apiSecret)
//       : _cloudinary = Cloudinary(
//     cloudName: cloudName,
//     apiKey: apiKey,
//     apiSecret: apiSecret,
//   );
//
//   // Upload image to Cloudinary and get the URL
//   Future<String?> uploadImage(File file) async {
//     try {
//       // Get the mime type of the file
//       final mimeType = await mime(file.path);
//       if (mimeType == null) return null;
//
//       final res = await _cloudinary.uploadFile(
//         filePath: file.path,
//         resourceType: CloudinaryResourceType.Image,
//         fileName: 'profile_picture.png',  // You can customize the name
//       );
//
//       if (res.isSuccessful) {
//         // Image upload successful, return the URL
//         return res.secureUrl;
//       } else {
//         throw Exception('Failed to upload image to Cloudinary');
//       }
//     } catch (e) {
//       throw Exception('Error uploading to Cloudinary: $e');
//     }
//   }
//
//   // Function to update Firebase with new photo URL
//   Future<void> updateFirebaseProfilePic(String photoUrl) async {
//     try {
//       User? user = FirebaseAuth.instance.currentUser;
//       if (user != null) {
//         final userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
//         await userRef.update({'photoUrl': photoUrl});
//       }
//     } catch (e) {
//       throw Exception('Error updating Firebase profile: $e');
//     }
//   }
// }
// */
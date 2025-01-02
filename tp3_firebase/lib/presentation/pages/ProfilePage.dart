import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  String? avatarUrl;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadAvatar();
  }

  Future<void> _loadAvatar() async {
    try {
      final ref = FirebaseStorage.instance.ref().child('avatar/${FirebaseAuth.instance.currentUser!.uid}.png');
      final url = await ref.getDownloadURL();
      setState(() {
        avatarUrl = url;
      });
    } catch (e) {
      setState(() {
        avatarUrl = null;
      });
    }
  }

  Future<void> _pickAndUploadImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final File file = File(pickedFile.path);
      try {
        final ref = FirebaseStorage.instance.ref().child('avatar/${FirebaseAuth.instance.currentUser!.uid}.png');
        await ref.putFile(file);
        final url = await ref.getDownloadURL();
        setState(() {
          avatarUrl = url;
        });
      } catch (e) {
        // Handle errors
      }
    }
  }

  Widget _getProfileCard(BuildContext context, String? avatarUrl, String email, Color textColor) {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(top: 50),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 60),
          Text(
            email,
            style: TextStyle(
              color: textColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _pickAndUploadImage,
            child: const Text('Change Avatar'),
          ),
        ],
      ),
    );
  }

Widget _getAvatar(String? avatarUrl) {
  return CircleAvatar(
    radius: 70,
    backgroundColor: Colors.transparent,
    backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl) : null,
    child: avatarUrl == null
        ? const Icon(Icons.person, size: 50)
        : ClipOval(
            child: Image.network(
              avatarUrl,
              fit: BoxFit.contain,
              width: 140,
              height: 140,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.error, size: 50, color: Colors.red);
              },
            ),
          ),
  );
}

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final textColor = Theme.of(context).textTheme.bodyMedium!.color!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            _getProfileCard(context, avatarUrl, user?.email ?? 'No email', textColor),
            Positioned(
              top: -50,
              left: 0,
              right: 0,
              child: _getAvatar(avatarUrl),
            ),
          ],
        ),
      ),
    );
  }
}
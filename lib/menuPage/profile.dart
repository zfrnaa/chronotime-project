import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // User data variables
  String userName = "";
  String email = "";
  String phoneNumber = "";
  String location = "Kuala Lumpur, Malaysia";
  String? profileImageBase64; // Store the base64 string
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        _fetchUserData(); // Refetch user data when the user logs in
      }
    });
  }

  Future<void> _fetchUserData() async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        email = user.email ?? "";

        QuerySnapshot querySnapshot = await _firestore
            .collection('users')
            .where('email', isEqualTo: email)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          DocumentSnapshot userDoc = querySnapshot.docs.first;

          setState(() {
            userName = userDoc['name'] ?? "Not Provided";
            phoneNumber = userDoc['number']?.toString() ?? "Not Provided";
            location = userDoc['location'] ?? "Kuala Lumpur, Malaysia";
            profileImageBase64 = userDoc['profileImage']; // Load base64 image
            isLoading = false;
          });
        } else {
          debugPrint("No user document found for email: $email");
          setState(() {
            isLoading = false;
          });
        }
      }
    } catch (e) {
      debugPrint("Error fetching user data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Profile', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 39, 72, 149),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: const Icon(Icons.edit),
              color: Colors.white,
              onPressed: _editUserProfile,
            ),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  _buildProfileHeader(),
                  _buildProfileInfo(),
                  _buildSettingsSection(),
                  _buildLogoutButton(),
                ],
              ),
            ),
    );
  }

  Widget _buildProfileHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            GestureDetector(
              onTap: _editUserProfile,
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white,
                child: profileImageBase64 != null
                    ? ClipOval(
                        child: Image.memory(
                          base64Decode(profileImageBase64!),
                          fit: BoxFit.cover,
                          width: 100,
                          height: 100,
                        ),
                      )
                    : ClipOval(
                        child: Image.asset(
                          'assets/lut.png',
                          fit: BoxFit.cover,
                          width: 100,
                          height: 100,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              userName.isNotEmpty ? userName : "User Name",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _editUserProfile() async {
    final nameController = TextEditingController(text: userName);
    final phoneController = TextEditingController(text: phoneNumber);
    final locationController = TextEditingController(text: location);

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Profile'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey[200],
                    child: profileImageBase64 != null
                        ? ClipOval(
                            child: Image.memory(
                              base64Decode(profileImageBase64!),
                              fit: BoxFit.cover,
                              width: 80,
                              height: 80,
                            ),
                          )
                        : const Icon(
                            Icons.camera_alt,
                            color: Colors.grey,
                          ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: phoneController,
                  decoration: const InputDecoration(labelText: 'Phone'),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: locationController,
                  decoration: const InputDecoration(labelText: 'Location'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  userName = nameController.text;
                  phoneNumber = phoneController.text;
                  location = locationController.text;
                });

                Navigator.pop(context);

                await _updateUserProfile();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  bool isImagePicking = false;

  Future<void> _pickImage() async {
    // Prevent multiple image pickers from being opened
    if (isImagePicking) return;

    isImagePicking = true; // Set flag to true
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        final imageBytes = await image.readAsBytes();
        if (mounted) {
          setState(() {
            profileImageBase64 = base64Encode(imageBytes);
          });
        }
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    } finally {
      isImagePicking = false; // Reset flag
    }
  }

  Future<void> _updateUserProfile() async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        await _firestore.collection('users').doc(user.uid).update({
          'name': userName,
          'number': phoneNumber,
          'location': location,
          'profileImage': profileImageBase64,
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Profile updated successfully")),
          );
        }
      }
    } catch (e) {
      debugPrint("Error updating profile: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error updating profile: $e")),
        );
      }
    }
  }

  Widget _buildProfileInfo() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Personal Information',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoCard('Phone Number', phoneNumber.isNotEmpty ? phoneNumber : "Not Provided", Icons.phone),
          _buildInfoCard('Email', email.isNotEmpty ? email : "Not Provided", Icons.email),
          _buildInfoCard('Location', location.isNotEmpty ? location : "Not Provided", Icons.location_on),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xff004CFF)),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Settings',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildSettingTile('Change Password', Icons.lock),
          _buildSettingTile('Notifications', Icons.notifications),
          _buildSettingTile('Privacy', Icons.security),
          _buildSettingTile('Help & Support', Icons.help),
        ],
      ),
    );
  }

  Widget _buildSettingTile(String title, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xff004CFF)),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        // Handle settings navigation
        switch (title) {
          case 'Change Password':
            Navigator.pushNamed(context, '/change_password');
            break;
          case 'Notifications':
            Navigator.pushNamed(context, '/notifications');
            break;
          case 'Privacy Policy':
            Navigator.pushNamed(context, '/privacy');
            break;
          case 'Help & Support':
            Navigator.pushNamed(context, '/help_support');
            break;
        }
      },
    );
  }

  Widget _buildLogoutButton() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ElevatedButton(
        onPressed: () {
          _auth.signOut();
          Navigator.pushNamed(context, '/login');
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          minimumSize: const Size(double.infinity, 50),
        ),
        child: const Text(
          'Logout',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

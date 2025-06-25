import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../service/translated_text.dart';

class ProfileDetailsScreen extends StatefulWidget {
  const ProfileDetailsScreen({Key? key}) : super(key: key);

  @override
  State<ProfileDetailsScreen> createState() => _ProfileDetailsScreenState();
}

class _ProfileDetailsScreenState extends State<ProfileDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  late FocusNode _nameFocusNode;
  late FocusNode _phoneFocusNode;
  late FocusNode _emailFocusNode;
  late FocusNode _addressFocusNode;

  bool _isEditing = false;
  String _name = 'Eleanor Pena';
  String _phone = '+91 9876543210';
  String _email = 'eleanor@gmail.com';
  String _address = 'No 2 R, 1st Street, Krishna Nagar, Chennai';
  String _imageUrl = 'https://randomuser.me/api/portraits/women/43.jpg';
  File? _profileImage; // Store the selected image file

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameFocusNode = FocusNode();
    _phoneFocusNode = FocusNode();
    _emailFocusNode = FocusNode();
    _addressFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _phoneFocusNode.dispose();
    _emailFocusNode.dispose();
    _addressFocusNode.dispose();
    super.dispose();
  }

  void _toggleEditing() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  Future<void> _pickImage() async {
    if (!_isEditing) return; // Only allow image picking in editing mode
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isEditing = false;
        // Simulate saving the image by updating _imageUrl (in a real app, upload to server)
        if (_profileImage != null) {
          _imageUrl = _profileImage!.path; // Use file path as placeholder
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: TranslatedText('Profile updated successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFF6B9D),
              Color(0xFFFFB6C1),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header with back button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const TranslatedText(
                      'Profile',
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: _toggleEditing,
                      icon: Icon(
                        _isEditing ? CupertinoIcons.xmark : CupertinoIcons.pencil,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),
              // Profile picture with upload option
              GestureDetector(
                onTap: _isEditing ? _pickImage : null,
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: _profileImage != null
                          ? FileImage(_profileImage!)
                          : NetworkImage(_imageUrl) as ImageProvider,
                      backgroundColor: Colors.grey[200],
                      child: _profileImage == null && _imageUrl.isEmpty
                          ? const Icon(
                        CupertinoIcons.person,
                        size: 40,
                        color: Colors.grey,
                      )
                          : null,
                    ),
                    if (_isEditing)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            CupertinoIcons.camera,
                            size: 18,
                            color: Color(0xFFFF6B9D),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              TranslatedText(
                _name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const TranslatedText(
                '@eleanor_testmode',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 25),
              // Scrollable form section
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    margin: const EdgeInsets.only(right: 10, left: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          _buildProfileField(
                            label: 'Full Name',
                            value: _name,
                            icon: CupertinoIcons.person,
                            focusNode: _nameFocusNode,
                            isEditing: _isEditing,
                            onSaved: (value) => _name = value!,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),
                          _buildProfileField(
                            label: 'Phone Number',
                            value: _phone,
                            icon: CupertinoIcons.phone,
                            focusNode: _phoneFocusNode,
                            isEditing: _isEditing,
                            keyboardType: TextInputType.phone,
                            onSaved: (value) => _phone = value!,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your phone number';
                              }
                              if (value.length < 10) {
                                return 'Enter a valid phone number';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),
                          _buildProfileField(
                            label: 'Email',
                            value: _email,
                            icon: CupertinoIcons.mail,
                            focusNode: _emailFocusNode,
                            isEditing: _isEditing,
                            keyboardType: TextInputType.emailAddress,
                            onSaved: (value) => _email = value!,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              if (!value.contains('@')) {
                                return 'Enter a valid email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),
                          _buildProfileField(
                            label: 'Address',
                            value: _address,
                            icon: CupertinoIcons.location,
                            focusNode: _addressFocusNode,
                            isEditing: _isEditing,
                            maxLines: 2,
                            onSaved: (value) => _address = value!,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your address';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 24),
                          if (_isEditing)
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: _saveChanges,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFFF6B9D),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  elevation: 0,
                                ),
                                child: const TranslatedText(
                                  'Save Changes',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileField({
    required String label,
    required String value,
    required IconData icon,
    required FocusNode focusNode,
    required bool isEditing,
    required FormFieldSetter<String> onSaved,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFFF6B9D), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: isEditing
                ? TextFormField(
              initialValue: value,
              focusNode: focusNode,
              keyboardType: keyboardType,
              maxLines: maxLines,
              onSaved: onSaved,
              validator: validator,
              decoration: InputDecoration(
                labelText: label,
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            )
                : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TranslatedText(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                TranslatedText(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          if (!isEditing)
            IconButton(
              icon: const Icon(CupertinoIcons.pencil, size: 18),
              onPressed: () {
                setState(() {
                  _isEditing = true;
                });
                focusNode.requestFocus();
              },
            ),
          const SizedBox(height: 70),
        ],
      ),
    );
  }
}
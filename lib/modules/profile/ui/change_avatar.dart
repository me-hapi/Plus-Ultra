import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lingap/core/const/colors.dart';
import 'package:lingap/core/const/const.dart';
import 'package:lingap/core/const/custom_button.dart';
import 'package:lingap/core/const/loading_screen.dart';
import 'package:lingap/modules/profile/data/supabase_db.dart';

class ChangeAvatar extends StatefulWidget {
  final String avatar;
  final String name;
  const ChangeAvatar({Key? key, required this.avatar, required this.name})
      : super(key: key);

  @override
  _ChangeAvatarState createState() => _ChangeAvatarState();
}

class _ChangeAvatarState extends State<ChangeAvatar> {
  final TextEditingController _nameController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _profileImage;
  late String _selectedAsset;
  final SupabaseDb _supabaseDb = SupabaseDb();

  @override
  void initState() {
    super.initState();
    _selectedAsset = widget.avatar;
    _nameController.text = widget.name;
  }

  final List<String> _profileAssets = List.generate(
    8,
    (index) => 'assets/profile/profile${index + 1}.png',
  );

  void _selectAsset(String asset) {
    setState(() {
      _selectedAsset = asset;
      _profileImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: mindfulBrown['Brown10'],
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(
                height: 50,
              ),
              Text(
                'Change name and avatar',
                textAlign: TextAlign.center,
                style: TextStyle(color: mindfulBrown['Brown80'], fontSize: 32),
              ),
              SizedBox(
                height: 50,
              ),
              GestureDetector(
                // onTap: _pickImage,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 120, // Adjust the size to fit the CircleAvatar
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: mindfulBrown['Brown80']!,
                          width: 4, // Border width
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: serenityGreen['Green50'],
                        backgroundImage: _profileImage != null
                            ? FileImage(_profileImage!)
                            : _selectedAsset != null
                                ? AssetImage(_selectedAsset!) as ImageProvider
                                : null,
                        child: (_profileImage == null && _selectedAsset == null)
                            ? Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 30,
                              )
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Focus(
                child: Builder(
                  builder: (context) {
                    final isFocused = Focus.of(context).hasFocus;
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: isFocused
                              ? serenityGreen['Green50']!
                              : Colors.transparent,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: isFocused
                            ? [
                                BoxShadow(
                                  color: serenityGreen['Green20']!,
                                  spreadRadius: 5,
                                  blurRadius: 0,
                                ),
                              ]
                            : [],
                      ),
                      child: TextField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Enter your name',
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              GridView.builder(
                shrinkWrap: true,
                itemCount: _profileAssets.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  final asset = _profileAssets[index];
                  final isSelected = _selectedAsset == asset;

                  return GestureDetector(
                    onTap: () => _selectAsset(asset),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected
                              ? serenityGreen['Green50']!
                              : Colors.transparent,
                          width: 3,
                        ),
                      ),
                      child: CircleAvatar(
                        backgroundImage: AssetImage(asset),
                      ),
                    ),
                  );
                },
              ),
              Spacer(),
              CustomButton(
                text: 'Change',
                onPressed: () async {
                  LoadingScreen.show(context);
                  _supabaseDb.updateNameAvatar(
                      _nameController.text, _selectedAsset);
                  final profile = await _supabaseDb.fetchProfile();
                  LoadingScreen.hide(context);
                  context.go('/bottom-nav');
                  Future.microtask(() {
                    context.push('/profile', extra: {
                      'bg': bgCons,
                      'profile': profile
                    }); // Adds Profile on top of Home
                  });
                },
                isPadding: false,
              ),
              SizedBox(
                height: 15,
              )
            ],
          ),
        ));
  }

  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Pick from Gallery'),
                onTap: () async {
                  Navigator.pop(context);
                  await _processImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Take a Picture'),
                onTap: () async {
                  Navigator.pop(context);
                  await _processImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<File?> _compressImage(File imageFile) async {
    final compressedFile = await FlutterImageCompress.compressWithFile(
      imageFile.path,
      minWidth: 800, // Adjust based on your needs
      minHeight: 800, // Adjust based on your needs
      quality: 85,
      format: CompressFormat.jpeg,
    );

    if (compressedFile == null) return null;

    final compressedImageFile = File('${imageFile.path}_compressed.jpg');
    await compressedImageFile.writeAsBytes(compressedFile);

    if (compressedImageFile.lengthSync() > 1000000) {
      return _compressImage(compressedImageFile);
    }

    return compressedImageFile;
  }

  Future<void> _processImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      final compressedImage = await _compressImage(File(pickedFile.path));
      setState(() {
        _profileImage = compressedImage;
      });
    }
  }
}

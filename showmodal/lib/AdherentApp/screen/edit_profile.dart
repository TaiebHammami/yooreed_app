import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:simple_shadow/simple_shadow.dart';

import '../../main.dart';
import '../Provider/offer_provider.dart';

class EditProfile extends StatefulWidget {
  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  var opacity = 0.05;

  late double _deviceWidth;

  late double _deviceHeight;
  late OfferProvider provider;
  File? _image;

  ImagePicker image = ImagePicker();

  /// controllers
  late TextEditingController nameController;
  late TextEditingController lastNameController;
  late TextEditingController numberController;
  late TextEditingController emailController;

  @override
  void initState() {
    provider = OfferProvider();

    emailController = TextEditingController();
    numberController =
        TextEditingController(text: provider.user.numero.toString());
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    numberController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      File? img = File(image.path);
      img = await _cropImage(img);
      setState(() {
        _image = img!;
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future<File?> _cropImage(File imageFile) async {
    CroppedFile? croppedImage =
        await ImageCropper().cropImage(sourcePath: imageFile.path);
    if (croppedImage == null) return null;
    return File(croppedImage.path);
  }

  late TextTheme theme;

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context).textTheme;
    final user = Provider.of<OfferProvider>(context).user;
    _deviceWidth = MediaQuery.of(context).size.width;
    _deviceHeight = MediaQuery.of(context).size.height;
    nameController = TextEditingController()..text = user.nom;
    lastNameController = TextEditingController()..text = user.email;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: SimpleShadow(
          opacity: 0.1,
          child: Text(
            'EDIT'.tr,
            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  fontSize: 26,
                ),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 12, right: 12),
          child: SingleChildScrollView(
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Center(
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        SimpleShadow(
                          opacity: 0.15,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 80,
                            child: _image == null
                                    ? CircleAvatar(
                                        radius: 75,
                                        backgroundImage:
                                            NetworkImage(user.image))
                                    : CircleAvatar(
                                        radius: 75,
                                        backgroundImage: FileImage(_image!)),
                          ),
                        ),
                        Positioned(
                          bottom: 2,
                          right: 0,
                          child: GestureDetector(
                            onTap: () {
                              Get.bottomSheet(
                                  Container(
                                    width: _deviceWidth,
                                    height: _deviceHeight * 0.25,
                                    decoration: BoxDecoration(
                                        color: Get.isDarkMode
                                            ? Colors.grey.shade900
                                            : Colors.grey.shade200,
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(16),
                                            topRight: Radius.circular(16))),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 12, left: 18, right: 18),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: 16,
                                          ),
                                          Text(
                                            'ADD_PROFILE_PHOTO'.tr,
                                            style: theme.subtitle1,
                                          ),
                                          SizedBox(
                                            height: _deviceHeight * 0.02,
                                          ),
                                          ListTile(
                                              minLeadingWidth: 20,
                                              onTap: () {
                                                pickImage(ImageSource.camera);
                                              },
                                              leading: Icon(
                                                  CupertinoIcons.camera_fill),
                                              title: Text('TAKE_A_PHOTO'.tr,
                                                  style: theme.bodyText1)),
                                          ListTile(
                                              minLeadingWidth: 20,
                                              onTap: () {
                                                pickImage(ImageSource.gallery);
                                              },
                                              leading: Icon(
                                                  CupertinoIcons.photo_fill),
                                              title: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text('UPLOAD_FROM_PHOTOS'.tr,
                                                      style: theme.bodyText1),
                                                  Text(
                                                    'YooreedUpload'.tr,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall
                                                        ?.copyWith(
                                                            fontSize: 11),
                                                    textAlign:
                                                        TextAlign.justify,
                                                  )
                                                ],
                                              )),
                                        ],
                                      ),
                                    ),
                                  ),
                                  backgroundColor: Theme.of(context)
                                      .bottomSheetTheme
                                      .backgroundColor);
                            },
                            child: SimpleShadow(
                              opacity: 0.06,
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                child: CircleAvatar(
                                    backgroundColor: HexColor('#E9564B'),
                                    radius: 13,
                                    child: Icon(
                                      CupertinoIcons.pen,
                                      size: 18,
                                      color: Colors.white,
                                    )),
                                radius: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: _deviceHeight * 0.04,
                ),
                Center(
                  child: Form(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SimpleShadow(
                        opacity: 0.07,
                        child: TextFormField(
                          onSaved: (password) {},
                          validator: (password) {
                            if (password!.isEmpty) {
                              return 'Required';
                            }
                          },
                          controller: lastNameController,
                          obscureText: true,
                          decoration: InputDecoration(
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide:
                                    BorderSide(color: Colors.grey.shade400),
                              ),
                              fillColor: Colors.white,
                              filled: true,
                              hintText: 'NAME'.tr,
                              hintStyle: TextStyle(color: Colors.grey[500])),
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      SimpleShadow(
                        opacity: 0.07,
                        child: TextFormField(
                          onSaved: (password) {},
                          validator: (password) {
                            if (password!.isEmpty) {
                              return 'Required';
                            }
                          },
                          controller: lastNameController,
                          obscureText: true,
                          decoration: InputDecoration(
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide:
                                    BorderSide(color: Colors.grey.shade400),
                              ),
                              fillColor: Colors.white,
                              filled: true,
                              hintText: 'NAME'.tr,
                              hintStyle: TextStyle(color: Colors.grey[500])),
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      SimpleShadow(
                        opacity: 0.07,
                        child: TextFormField(
                          onSaved: (password) {},
                          validator: (password) {
                            if (password!.isEmpty) {
                              return 'Required';
                            }
                          },
                          controller: lastNameController,
                          obscureText: true,
                          decoration: InputDecoration(
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide:
                                    BorderSide(color: Colors.grey.shade400),
                              ),
                              fillColor: Colors.white,
                              filled: true,
                              hintText: 'NAME'.tr,
                              hintStyle: TextStyle(color: Colors.grey[500])),
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      SimpleShadow(
                        opacity: 0.07,
                        child: TextFormField(
                          onSaved: (password) {},
                          validator: (password) {
                            if (password!.isEmpty) {
                              return 'Required';
                            }
                          },
                          controller: lastNameController,
                          obscureText: true,
                          decoration: InputDecoration(
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide:
                                    BorderSide(color: Colors.grey.shade400),
                              ),
                              fillColor: Colors.white,
                              filled: true,
                              hintText: 'NAME'.tr,
                              hintStyle: TextStyle(color: Colors.grey[500])),
                        ),
                      ),
                    ],
                  )),
                ),
                SizedBox(
                  height: _deviceHeight * 0.05,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: HexColor('#E9564B'),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                        topRight: Radius.circular(26),
                        bottomRight: Radius.circular(26),
                        topLeft: Radius.circular(12),
                        bottomLeft: Radius.circular(26),
                      )),
                      maximumSize: Size(double.infinity, 65),
                      minimumSize: Size(double.infinity, 55),
                    ),
                    onPressed: () {
                      print(_image!.path);
                    },
                    child: Text(
                      'SAVE'.tr,
                      style: Theme.of(context).textTheme.titleLarge,
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

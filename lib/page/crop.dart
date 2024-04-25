import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:imagecompressorandresizer/utils/color.dart';

class CropPage extends StatefulWidget {
  const CropPage({super.key});

  @override
  State<CropPage> createState() => _CropPageState();
}

class _CropPageState extends State<CropPage> {
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  CroppedFile? _croppedFile;

  // Image Picker Method
  Future _pickImageFromGallery() async {
    final returnImage = await _picker.pickImage(source: ImageSource.gallery);
    if (returnImage == null) return;


    final croppedImage = await cropImages(returnImage);
    if(!mounted)return;

    setState(() {
      _selectedImage = File(returnImage.path);
    });
    _saveImage(File(croppedImage.path));
  }

  Future<CroppedFile> cropImages(XFile image) async {
    final croppedFile = await ImageCropper()
        .cropImage(sourcePath: image.path, aspectRatioPresets: [
      CropAspectRatioPreset.square,
      CropAspectRatioPreset.ratio4x3,
      CropAspectRatioPreset.original,
      CropAspectRatioPreset.ratio7x5,
      CropAspectRatioPreset.ratio16x9
    ],
        uiSettings: [
      AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: backgroundColor,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false)
    ]);
    return croppedFile!;
  }

  // Save Image
  void _saveImage(File image) async {
    try {
      final result = await ImageGallerySaver.saveFile(
        image.path,
      );
      if (result != null && result.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Image saved to gallery'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save image'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Crop Image",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: backgroundColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        // actions: [
        //   IconButton(
        //       icon: Icon(
        //         Icons.check,
        //         color: Colors.white,
        //       ),
        //       onPressed: () {
        //         print("Croped");
        //       })
        // ],
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                color: Colors.black,
                child: _selectedImage != null
                    ? Image.file(
                        _selectedImage!,
                        fit: BoxFit.fill,
                      )
                    : Container(
                        alignment: Alignment.center,
                        width: size.width,
                        child: ElevatedButton(
                          child: Text(
                            "Select Image",
                            style: TextStyle(fontSize: 20),
                          ),
                          onPressed: () async {
                            await _pickImageFromGallery();
                          },
                        ),
                      ),
              ),
            ),
            // Container(
            //   height: 100,
            //   color: Colors.green,
            // ),
            // Container(
            //   width: size.width,
            //   height: size.height/16,
            //   color: backgroundColor,
            //   child: ElevatedButton(
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: backgroundColor
            //     ),
            //     child: Text("Select Image",style: TextStyle(fontSize: 20,color: Colors.white),),
            //     onPressed: ()async{
            //       await _pickImageFromGallery();
            //     },
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}

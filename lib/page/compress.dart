import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:imagecompressorandresizer/page/compressed_image.dart';
import 'package:imagecompressorandresizer/utils/color.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class CompressPage extends StatefulWidget {
  const CompressPage({super.key});

  @override
  State<CompressPage> createState() => _CompressPageState();
}

class _CompressPageState extends State<CompressPage> {
  final TextEditingController percentageController = TextEditingController();
  double progress = 0.0;

  final ImagePicker imagePicker = ImagePicker();
  List<XFile> imageFileList = [];
  List<String> imageSizes = [];

  List<String> originalImageSizes = [];
  List<String> compressedImageSizes = [];

  List<String> imageResolutions = [];
  int currentPageIndex = 0;
  // double compressionProgress = 0;

  // Multiple Image Picker
  void selectImage() async {
    final List<XFile>? selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages!.isNotEmpty) {
      imageFileList.addAll(selectedImages);

      for (var file in selectedImages) {
        File image = File(file.path);
        int sizeInBytes = image.lengthSync();
        double sizeInKB = sizeInBytes / 1024;
        String sizeText;
        if (sizeInKB > 1024) {
          double sizeInMB = sizeInKB / 1024;
          sizeText = "${sizeInMB.toStringAsFixed(2)} MB";
        } else {
          sizeText = "${sizeInKB.toStringAsFixed(2)} KB";
        }
        imageSizes.add(sizeText);

        // Fetching image resolution
        ui.Image resolvedImage =
            await decodeImageFromList(await image.readAsBytes());
        imageResolutions.add('${resolvedImage.width}x${resolvedImage.height}');
      }
    }
    setState(() {});
  }

  //Compress Image
  Future<List<File>> compressImages(double percentage) async {
    List<File> compressedImages = [];

    for (var file in imageFileList) {
      Uint8List? compressedData = await FlutterImageCompress.compressWithFile(
        file.path,
        quality: (percentage * 100).toInt(),
      );

      // Save the compressed image to a temporary file
      final Directory tempDir = Directory.systemTemp;
      final String tempPath =
          '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
      File tempFile = await File(tempPath).writeAsBytes(compressedData!);

      compressedImages.add(tempFile);

      // Get the size of the original image
      int originalSizeInBytes = await file.length();
      double originalSizeInKB = originalSizeInBytes / 1024;
      String originalSizeText;
      if (originalSizeInKB > 1024) {
        double originalSizeInMB = originalSizeInKB / 1024;
        originalSizeText = "${originalSizeInMB.toStringAsFixed(2)} MB";
      } else {
        originalSizeText = "${originalSizeInKB.toStringAsFixed(2)} KB";
      }
      originalImageSizes.add(originalSizeText);

      // Get the size of the compressed image
      int compressedSizeInBytes = await tempFile.length();
      double compressedSizeInKB = compressedSizeInBytes / 1024;
      String compressedSizeText;
      if (compressedSizeInKB > 1024) {
        double compressedSizeInMB = compressedSizeInKB / 1024;
        compressedSizeText = "${compressedSizeInMB.toStringAsFixed(2)} MB";
      } else {
        compressedSizeText = "${compressedSizeInKB.toStringAsFixed(2)} KB";
      }
      compressedImageSizes.add(compressedSizeText);

    }

    return compressedImages;
  }



  @override
  void initState() {
    super.initState();
    imageSizes = [];
    imageResolutions = [];
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Compress Image"),
        backgroundColor: backgroundColor,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 5,
              ),
              Container(
                height: size.height / 3,
                color: Colors.black,
                child: PageView.builder(
                    itemCount: imageFileList.length,
                    onPageChanged: (int index) {
                      setState(() {
                        currentPageIndex = index;
                      });
                    },
                    itemBuilder: (BuildContext context, int index) {
                      return Image.file(
                        File(
                          imageFileList[index].path,
                        ),
                        fit: BoxFit.cover,
                      );
                    }),
              ),
              imageFileList!.isNotEmpty
                  ? Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      color: Colors.black,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Selected",
                                style: TextStyle(fontSize: 16,color: Colors.white),
                              ),
                              Text(
                                "${imageFileList.length} images",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold,color: Colors.white),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Size",
                                style: TextStyle(fontSize: 16,color: Colors.white),
                              ),
                              Text(
                                "${imageSizes.isNotEmpty && currentPageIndex < imageSizes.length ? imageSizes[currentPageIndex] : ''}",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold,color: Colors.white),
                              )
                            ],
                          ),
                        ],
                      ),
                    )
                  : SizedBox(),
              Center(
                child: SizedBox(
                    width: size.width-100,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero)),
                        onPressed: selectImage,
                        child: Text(
                          "Select Image",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ))),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  "Select Compress ",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Row(
                  children: [
                    Center(
                      child: SizedBox(
                        width: 80,
                        child: TextField(
                          controller: percentageController,
                          onChanged: (value) {
                            setState(() {
                              if (value.isNotEmpty) {
                                progress = double.parse(value) / 100.0;
                              } else {
                                progress = 0.0;
                              }
                            });
                          },
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              suffixIcon: Icon(Icons.percent)),
                        ),
                      ),
                    ),
                    Expanded(
                      child: LinearPercentIndicator(
                        lineHeight: 16,
                        percent: progress,
                        center: Text(""),
                        backgroundColor: Colors.brown,
                        progressColor: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 50,),
              percentageController.text.isNotEmpty
                  ? SizedBox(
                                  height: 50,
                  width: size.width,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero)),
                      child: Text(
                        "COMPRESS",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    onPressed: () async {
                      if (percentageController.text.isNotEmpty) {
                        double percentage =
                            double.parse(percentageController.text) / 100;
                        List<File> compressedImages =
                        await compressImages(percentage);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DisplayCompressedImagesPage(
                              compressedImages: compressedImages,
                              originalImageSizes: originalImageSizes,
                              compressedImageSizes: compressedImageSizes,
                            ),
                          ),
                        );
                      }
                    },
                  )
              )
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}

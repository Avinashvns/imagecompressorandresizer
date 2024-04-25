import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:imagecompressorandresizer/utils/color.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';



class CompressPage extends StatefulWidget {
  const CompressPage({super.key});

  @override
  State<CompressPage> createState() => _CompressPageState();
}

class _CompressPageState extends State<CompressPage> {
  final TextEditingController percentageController=TextEditingController();
  double progress = 0.0;

  final ImagePicker imagePicker = ImagePicker();
  List<XFile> imageFileList = [];
  List<String> imageSizes = [];
  List<String> imageResolutions = [];
  int currentPageIndex = 0;
  double compressionProgress = 0;

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

  @override
  void initState() {
    super.initState();
    imageSizes = [];
    imageResolutions = [];
  }

  // Compress image by 50%
  void compressAndShowProgress(File imageFile,int percent) async {
    Uint8List? uint8list = await FlutterImageCompress.compressWithFile(
      imageFile.path,
      quality: percent,
    );
    // You can do something with the compressed image, like saving it or displaying it

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
                height: 10,
              ),
              Container(
                height: size.height / 3,
                color: Colors.green,
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
                      color: Colors.yellow,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Selected",
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(
                                "${imageFileList.length} images",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Size",
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(
                                "${imageSizes.isNotEmpty && currentPageIndex < imageSizes.length ? imageSizes[currentPageIndex] : ''}",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ],
                      ),
                    )
                  : SizedBox(),
          
              SizedBox(
                  width: size.width,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: backgroundColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero)),
                      onPressed: selectImage,
                      child: Text(
                        "Select Image",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ))
              ),
              Text("Select Compress ",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
          
              Row(
                children: [
                  Center(
                    child: SizedBox(
                      width: 80,
                      child: TextField(
                        controller: percentageController,
                      onChanged: (value){
                          setState(() {
                            if(value.isNotEmpty){
                              progress=double.parse(value)/100.0;
                            }else{
                              progress=0.0;
                            }
                          });
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.percent)
                      ),
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
          
            ],
          ),
        ),
      ),
    );
  }
}

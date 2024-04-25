import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:image_picker/image_picker.dart';
import 'package:imagecompressorandresizer/utils/color.dart';

class CompressPage extends StatefulWidget {
  const CompressPage({super.key});

  @override
  State<CompressPage> createState() => _CompressPageState();
}

class _CompressPageState extends State<CompressPage> {
  final ImagePicker imagePicker = ImagePicker();
  List<XFile> imageFileList = [];
  List<String> imageSizes = [];
  List<String> imageResolutions = [];
  int currentPageIndex = 0;

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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Compress Image"),
        backgroundColor: backgroundColor,
      ),
      // body: SafeArea(
      //   child: Column(
      //     children: [
      //       SizedBox(height: 10,),
      //       Container(
      //         height: size.height/3,
      //         color: Colors.green,
      //         child: Row(
      //           children: [
      //             Container(
      //               padding: const EdgeInsets.all(10),
      //               width: size.width/1.4,
      //               child: ListView.builder(
      //                 scrollDirection: Axis.horizontal,
      //                 itemCount: imageFileList!.length,
      //                   itemBuilder: (BuildContext context, int index){
      //                     return Image.file(
      //                       File(imageFileList[index].path,),
      //                       fit: BoxFit.fill,
      //                     );
      //                   }
      //               ),
      //             ),
      //             Expanded(
      //               child: Container(
      //                 padding: const EdgeInsets.symmetric(vertical: 20),
      //                 color: Colors.yellow,
      //                 child: Column(
      //                   crossAxisAlignment: CrossAxisAlignment.start,
      //                   children: [
      //                     Text("Selected",style: TextStyle(fontSize: 16),),
      //                     Text("${imageFileList!.length} images",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
      //                     SizedBox(height: 10,),
      //                     Text("Sized",style: TextStyle(fontSize: 16),),
      //
      //                     Column(
      //                       crossAxisAlignment: CrossAxisAlignment.start,
      //                       children: imageSizes.asMap().entries.map((entry) {
      //                         int index = entry.key;
      //                         String sizeText = entry.value;
      //                         return Text("$sizeText", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),);
      //                       }).toList(),
      //                     ),
      //                     SizedBox(height: 10,),
      //                   ],
      //                 ),
      //               ),
      //             )
      //           ],
      //         ),
      //       ),
      //       SizedBox(
      //         width: size.width,
      //           child: ElevatedButton(
      //             style: ElevatedButton.styleFrom(
      //               backgroundColor: backgroundColor,
      //               shape: RoundedRectangleBorder(
      //                 borderRadius: BorderRadius.zero
      //               )
      //             ),
      //               onPressed: (){
      //               selectImage();
      //               },
      //               child: Text("Select Image",style: TextStyle(fontSize: 18,color: Colors.white),)
      //           )
      //       ),
      //
      //
      //     ],
      //   ),
      // ),
      body: SafeArea(
        child: Column(
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
                        // Column(
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: [
                        //     Text(
                        //       "Resolution",
                        //       style: TextStyle(fontSize: 16),
                        //     ),
                        //     Text(
                        //       "${imageResolutions.isNotEmpty && currentPageIndex < imageResolutions.length ? imageResolutions[currentPageIndex] : ''}",
                        //       style: TextStyle(
                        //           fontSize: 16, fontWeight: FontWeight.bold),
                        //     ),
                        //   ],
                        // ),
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
            Text("Select Compress ",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)
            
          ],
        ),
      ),
    );
  }
}

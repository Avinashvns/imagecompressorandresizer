

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:imagecompressorandresizer/utils/color.dart';

class CompressPage extends StatefulWidget {
  const CompressPage({super.key});

  @override
  State<CompressPage> createState() => _CompressPageState();
}

class _CompressPageState extends State<CompressPage> {
  final ImagePicker imagePicker=ImagePicker();
  List<XFile> imageFileList=[];
  List<String> imageSizes=[];

  // Multiple Image Picker
  void selectImage()async{
    final List<XFile>? selectedImages=await imagePicker.pickMultiImage();
    if(selectedImages!.isNotEmpty){
      imageFileList!.addAll(selectedImages);
    }
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Compress Image"),
        backgroundColor: backgroundColor,
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 10,),
            Container(
              height: size.height/3,
              color: Colors.green,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    width: size.width/1.4,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: imageFileList!.length,
                        itemBuilder: (BuildContext context, int index){
                          return Image.file(
                            File(imageFileList[index].path,),
                            fit: BoxFit.cover,
                          );
                        }
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      color: Colors.yellow,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Selected",style: TextStyle(fontSize: 16),),
                          Text("${imageFileList!.length} images",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                          SizedBox(height: 10,),
                          Text("Sized",style: TextStyle(fontSize: 16),),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: imageFileList.map((XFile file) {
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
                              return Text("$sizeText", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),);
                            }).toList(),
                          ),
                          SizedBox(height: 10,),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              width: size.width,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: backgroundColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero
                    )
                  ),
                    onPressed: (){
                    selectImage();
                    },
                    child: Text("Select Image",style: TextStyle(fontSize: 18,color: Colors.white),)
                )
            ),


          ],
        ),
      ),
    );
  }
}

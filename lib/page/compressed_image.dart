import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';


class DisplayCompressedImagesPage extends StatefulWidget {
  final List<File> compressedImages;
  final List<String> originalImageSizes;
  final List<String> compressedImageSizes;

  DisplayCompressedImagesPage({
    required this.compressedImages,
    required this.originalImageSizes,
    required this.compressedImageSizes,
  });

  @override
  State<DisplayCompressedImagesPage> createState() =>
      _DisplayCompressedImagesPageState();
}

class _DisplayCompressedImagesPageState
    extends State<DisplayCompressedImagesPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey=GlobalKey<ScaffoldState>();

  void _saveAllImages() async {
    for (int i = 0; i < widget.compressedImages.length; i++) {
      try {
        final result = await ImageGallerySaver.saveFile(
          widget.compressedImages[i].path,
        );
        if (result != null && result.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Images saved to gallery'),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to save images'),
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
  }

  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Compressed Images"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: size.height/1.5,
              child: ListView.builder(
                // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                itemCount: widget.compressedImages.length,
                  itemBuilder: (context,index){
                  return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Stack(
                      children: [
                        Image.file(widget.compressedImages[index]),
                        Positioned(
                            right: -1,
                            bottom: 4,
                            child: Row(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 4,
                                      color: Colors.red
                                    )
                                  ),
                                  child: Text(
                                    "${widget.originalImageSizes.isNotEmpty ? widget.originalImageSizes[index] : 'Calculating...'}",
                                    style: TextStyle(fontSize: 16,color: Colors.white,fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Icon(Icons.arrow_forward,color: Colors.white,),
                                Container(
                                  alignment: Alignment.center,
                                  width: 100,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 4,
                                          color: Colors.green
                                      )
                                  ),
                                  child: Text(
                                    " ${widget.compressedImageSizes.isNotEmpty ? widget.compressedImageSizes[index] : 'Calculating...'}",
                                    style: TextStyle(fontSize: 16,color: Colors.white,fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SizedBox(width: 10,),
                              ],
                            )
                        )
                      ],
                    ),
                  );
                  }
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveAllImages,
              child: Text('Save All'),
            ),
          ],
        ),
      )
    );
  }
}

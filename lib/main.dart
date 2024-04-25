import 'package:flutter/material.dart';
import 'package:imagecompressorandresizer/widget/clip_clipper.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.brown.shade200,
      body: SafeArea(
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Container
                ClipPath(
                  clipper: ClipsClipper(),
                  child: Container(
                    height: size.height / 2,
                    color: Colors.red,
                  ),
                ),

                SizedBox(
                  height: 10,
                ),

                // Compress Image
                GestureDetector(
                  child: Card(
                    margin: const EdgeInsets.all(10),
                    child: ListTile(
                      leading: Image(
                        image: AssetImage("assets/images/compress.png"),
                      ),
                      title: Text(
                        "Compress Images",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'PlayfairDisplay'),
                      ),
                      subtitle: Text(
                        "Reduce Images file size",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  onTap: () {
                    print("Compress Image");
                  },
                ),

                // Resize Image
                GestureDetector(
                  child: Card(
                    margin: const EdgeInsets.all(10),
                    child: ListTile(
                      leading: Image(
                        image: AssetImage("assets/images/resize.png"),
                      ),
                      title: Text(
                        "Resize Images",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'PlayfairDisplay'),
                      ),
                      subtitle: Text(
                        "Reduce Images width & height",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  onTap: () {
                    print("Resize Image");
                  },
                ),

                // Crop Image
                GestureDetector(
                  child: Card(
                    margin: const EdgeInsets.all(10),
                    child: ListTile(
                      leading: Image(
                        image: AssetImage("assets/images/crop.png"),
                      ),
                      title: Text(
                        "Crop Images",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'PlayfairDisplay'),
                      ),
                      subtitle: Text(
                        "Easily crop your image",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  onTap: () {
                    print("Crop Image");
                  },
                ),

                // Convert Image Formate
                GestureDetector(
                  child: Card(
                    margin: const EdgeInsets.all(10),
                    child: ListTile(
                      leading: Image(
                        image: AssetImage("assets/images/convert.png"),
                      ),
                      title: Text(
                        "Convert Image Format",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'PlayfairDisplay'),
                      ),
                      subtitle: Text(
                        "Image convert another format",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  onTap: () {
                    print("Convert Image");
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



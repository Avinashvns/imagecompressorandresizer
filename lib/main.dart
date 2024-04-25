

import 'package:flutter/material.dart';

void main(){
  runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MyApp(),
      )
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Card(
                child: ListTile(
                  leading: Icon(Icons.add),
                  title: Text("Compress Images" ,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,fontFamily: 'PlayfairDisplay'),),
                  subtitle: Text("Reduce Images file size",style: TextStyle(fontSize: 16),),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}

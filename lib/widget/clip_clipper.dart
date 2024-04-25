

import 'package:flutter/material.dart';

class ClipsClipper extends CustomClipper<Path>{
  @override
  Path getClip(Size size){
    Path path=Path();

    // path.lineTo(0,size.height);
    // // path.quadraticBezierTo(0, 0, 50, 600);
    // path.lineTo(size.width, size.height);
    //
    // path.lineTo(size.width, 0);
    //
    // // path.quadraticBezierTo(size.width, 0, 0, 0);

    path.lineTo(0, size.height);
    var firstStart= Offset(size.width/5, size.height);
    var firstEnd=Offset(size.width/2.25, size.height-40.0);
    path.quadraticBezierTo(firstStart.dx, firstStart.dy, firstEnd.dx, firstEnd.dy);

    var secondStart=Offset(size.width-(size.width/3.24),size.height-80);
    var secondEnd=Offset(size.width, size.height-10);
    path.quadraticBezierTo(secondStart.dx, secondStart.dy, secondEnd.dx, secondEnd.dy);
    path.lineTo(size.width, 0);

    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
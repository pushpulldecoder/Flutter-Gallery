import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'xGesture/gesture_x_detector.dart';

class ImageGallery extends StatefulWidget {
  final List<String> files;
  final int index;
  final double maxZoom;
  final double minZoom;
  final Color backgroundColor;
  final Color appbarColor;

  ImageGallery(
      {Key key,
      @required this.files,
      this.index,
      this.maxZoom,
      this.minZoom,
      this.backgroundColor = const Color.fromRGBO(17, 17, 17, 1),
      this.appbarColor = const Color.fromRGBO(47, 47, 47, 1)})
      : super(key: key);

  @override
  _ImageGalleryState createState() => new _ImageGalleryState();
}

class _ImageGalleryState extends State<ImageGallery> {
  double scale = 0.0;
  double _scaleFactor = 1.0;
  double _baseScaleFactor = 1.0;

  double d_x = 0;
  double d_y = 0;

  double x0 = 0;
  double y0 = 0;

  int index;

  int noTap = 0;

  @override
  void initState() {
    super.initState();
    index = widget.index;
    print(widget.index);
  }

  @override
  Widget build(BuildContext context) {
    print("From ImageViewer build method");
    return Scaffold(
        appBar: AppBar(
          title: Container(
            child: AnimatedSwitcher(
                duration: Duration(milliseconds: 310),
                child: Text(
                  (index + 1).toString() +
                      " of " +
                      widget.files.length.toString(),
                  key: ValueKey(index),
                )),
          ),
          elevation: 0,
          backgroundColor: widget.appbarColor,
        ),
        body: Container(
          color: widget.backgroundColor,
          child: Stack(
            children: [
              Container(
                // padding: EdgeInsets.fromLTRB(13, 13, 13, 31),
                child: XGestureDetector(
                  onTap: (pointer, localPos, position) {
                    print(_scaleFactor);
                  },
                  onDoubleTap: (localPos, position) {
                    if (_scaleFactor >= widget.maxZoom) {
                      Timer.periodic(Duration(milliseconds: 1), (Timer t) {
                        if (_scaleFactor > widget.minZoom) {
                          print(_scaleFactor);
                          setState(() {
                            _scaleFactor -= 0.01;
                          });
                        } else {
                          t.cancel();
                        }
                      });
                    } else if (_scaleFactor >
                        (widget.minZoom + widget.maxZoom) / 2) {
                      Timer.periodic(Duration(milliseconds: 1), (Timer t) {
                        if (_scaleFactor < widget.maxZoom) {
                          print(_scaleFactor);
                          setState(() {
                            _scaleFactor += 0.01;
                          });
                        } else {
                          t.cancel();
                        }
                      });
                    } else if (_scaleFactor <
                        (widget.minZoom + widget.maxZoom) / 2) {
                      Timer.periodic(Duration(milliseconds: 1), (Timer t) {
                        if (_scaleFactor <
                            (widget.minZoom + widget.maxZoom) / 2) {
                          print(_scaleFactor);
                          setState(() {
                            _scaleFactor += 0.01;
                          });
                        } else {
                          t.cancel();
                        }
                      });
                    }
                  },
                  onMoveUpdate: (localPos, position, localDelta, delta) {
                    setState(() {
                      d_x += delta.dx / _scaleFactor;
                      d_y += delta.dy / _scaleFactor;
                    });
                  },
                  onScaleStart: (initialFocusPoint) {
                    setState(() {
                      _baseScaleFactor = _scaleFactor;
                    });
                  },
                  onScaleUpdate: (changedFocusPoint, scale, rotation) {
                    setState(() {
                      print(_scaleFactor);
                      if ((_baseScaleFactor * scale > (widget.minZoom * 0.7)) &&
                          (_baseScaleFactor * scale < (widget.maxZoom * 1.7))) {
                        _scaleFactor = _baseScaleFactor * scale;
                      }
                    });
                  },
                  onScaleEnd: () {
                    Timer.periodic(Duration(milliseconds: 1), (Timer t) {
                      if (_scaleFactor < 1.0) {
                        setState(() {
                          _scaleFactor += 0.01;
                        });
                      } else if (_scaleFactor > widget.maxZoom) {
                        setState(() {
                          _scaleFactor -= 0.01;
                        });
                      } else {
                        t.cancel();
                      }
                    });
                  },
                  child: AnimatedSwitcher(
                    duration: Duration(milliseconds: 310),
                    child: Transform(
                      key: ValueKey(index),
                      alignment: FractionalOffset.center,
                      transform: Matrix4(
                        1,
                        0,
                        0,
                        0,
                        0,
                        1,
                        0,
                        0,
                        0,
                        0,
                        1,
                        0,
                        0,
                        0,
                        0,
                        1,
                      )
                        ..scale(_scaleFactor)
                        ..translate(d_x, d_y),
                      child: Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image:
                                    Image.file(File(widget.files[index])).image,
                                fit: BoxFit.contain)),
                      ),
                    ),
                  ),
                ),
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    index != 0
                        ? IconButton(
                            iconSize: 47,
                            icon: Icon(
                              Icons.arrow_left_rounded,
                              size: 47,
                              color: Color.fromRGBO(47, 47, 47, 1),
                            ),
                            onPressed: () {
                              print("back");
                              // diaryData.attachments.removeAt(index);
                              setState(() {
                                if (index > 0) {
                                  index -= 1;
                                }
                              });
                            })
                        : Container(),
                    index != widget.files.length - 1
                        ? IconButton(
                            iconSize: 47,
                            icon: Icon(
                              Icons.arrow_right_rounded,
                              size: 47,
                              color: Color.fromRGBO(47, 47, 47, 1),
                            ),
                            onPressed: () {
                              print("next");
                              // diaryData.attachments.removeAt(index);
                              setState(() {
                                if (index < widget.files.length - 1) {
                                  index += 1;
                                }
                              });
                            })
                        : Container()
                  ],
                ),
              )
            ],
          ),
        ));
  }
}

// class _InteractiveImageState extends State<ImageGallary> {
//   double _scale = 1.0;
//   double _previousScale = null;
//   double scale = 0.0;
//   double _scaleFactor = 1.0;
//   double _baseScaleFactor = 1.0;
//   double _savedVal = 1.0;
//
//   double d_x = 0;
//   double d_y = 0;
//
//   double x0 = 0;
//   double y0 = 0;
//
//   int index;
//
//   int noTap = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     index = widget.index;
//     print(widget.index);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     print("From ImageViewer build method");
//     return Scaffold(
//         appBar: AppBar(
//           // leading: ButtonTheme(
//           //   minWidth: 31,
//           //   padding: EdgeInsets.all(0),
//           //   child: FlatButton(
//           //       child: SvgPicture.asset(
//           //         "assets/icons/back2.svg",
//           //         height: 27,
//           //         width: 27,
//           //         color: Color.fromRGBO(213, 213, 213, 1),
//           //       ),
//           //       onPressed: () {
//           //         Navigator.of(context).pop();
//           //       }),
//           // ),
//           leading: Container(
//             padding: EdgeInsets.all(3),
//             child: ButtonTheme(
//               minWidth: 31,
//               padding: EdgeInsets.all(7),
//               child: FlatButton(
//                 child: SvgPicture.asset(
//                   "assets/icons/back2.svg",
//                   height: 47,
//                   width: 47,
//                   color: Color.fromRGBO(213, 213, 213, 1),
//                 ),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//               ),
//             ),
//           ),
//           title: Container(
//             child: AnimatedSwitcher(
//                 duration: Duration(milliseconds: 310),
//                 child: Text(
//                   (index + 1).toString() + " of " + widget.files.length.toString(),
//                   key: ValueKey(index),
//                   style: GoogleFonts.ubuntu(color: Color.fromRGBO(213, 213, 213, 1)),
//                 )),
//           ),
//           actions: [
//             Container(
//               padding: EdgeInsets.all(3),
//               child: ButtonTheme(
//                 minWidth: 31,
//                 padding: EdgeInsets.all(7),
//                 child: FlatButton(
//                   child: SvgPicture.asset(
//                     "assets/icons/trash.svg",
//                     height: 47,
//                     width: 47,
//                     color: Color.fromRGBO(213, 213, 213, 1),
//                   ),
//                   onPressed: () {},
//                 ),
//               ),
//             ),
//           ],
//           elevation: 0,
//           backgroundColor: Color.fromRGBO(47, 47, 47, 1),
//         ),
//         body: Container(
//           color: Color.fromRGBO(17, 17, 17, 1),
//           child: Stack(
//             children: [
//               Container(
//                 padding: EdgeInsets.fromLTRB(13, 13, 13, 31),
//                 child: AnimatedSwitcher(
//                     duration: Duration(milliseconds: 310),
//                     // child: InteractiveViewer(
//                     //     key: ValueKey(widget.files[index].toString()),
//                     //     minScale: 0.71,
//                     //     maxScale: 2.1,
//                     //     child: Container(
//                     //       decoration: BoxDecoration(image: DecorationImage(image: Image.file(File(widget.files[index])).image, fit: BoxFit.contain)),
//                     //     )),
//                     child: GestureDetector(
//                       onDoubleTap: () {
//                           print("tap");
//                           if (_scaleFactor < 1.1) {
//                             Timer.periodic(Duration(milliseconds: 1), (Timer t) {
//                               if(_scaleFactor>2.0){
//                                 t.cancel();
//                               }
//                               else{
//                                 setState(() {
//                                   _scaleFactor+=0.01;
//                                 });
//                               }
//                             });
//                           } else {
//                             Timer.periodic(Duration(milliseconds: 1), (Timer t) {
//                               if(_scaleFactor<1.0){
//                                 t.cancel();
//                               }
//                               else{
//                                 setState(() {
//                                   _scaleFactor-=0.01;
//                                 });
//                               }
//                             });
//                           }
//                       },
//                       // onVerticalDragUpdate: (dragDet) {
//                       //   print(dragDet.delta.dy);
//                       //   setState(() {
//                       //     d_y += dragDet.delta.dy/_scaleFactor;
//                       //   });
//                       // },
//                       // onHorizontalDragUpdate: (dragDet) {
//                       //   print(dragDet.delta.dx);
//                       //   setState(() {
//                       //     d_x += dragDet.delta.dx/_scaleFactor;
//                       //   });
//                       // },
//                       // onPanUpdate: (panDetail) {
//                       //     setState(() {
//                       //       d_x += panDetail.delta.dx/_scaleFactor;
//                       //       d_y += panDetail.delta.dy/_scaleFactor;
//                       //     });
//                       // },
//                       onScaleStart: (details) {
//                         setState(() {
//                           // d_x = details.focalPoint.dx;
//                           // d_y = details.focalPoint.dy;
//                         });
//                       },
//                       onScaleUpdate: (details) {
//                         // print("scaling");
//                         print(details.focalPoint.dx);
//                         setState(() {
//                           d_x += (details.focalPoint.dx - x0)/_scaleFactor;
//                           d_y += (details.focalPoint.dy - y0)/_scaleFactor;
//                           x0 = d_x;
//                           y0 = d_y;
//                           // d_x = details.focalPoint.dx/_scaleFactor;
//                         });
//                       },
//                       child: Transform(
//                         transform: Matrix4(
//                           1,
//                           0,
//                           0,
//                           0,
//                           0,
//                           1,
//                           0,
//                           0,
//                           0,
//                           0,
//                           1,
//                           0,
//                           0,
//                           0,
//                           0,
//                           1,
//                         )
//                           ..scale(_scaleFactor)
//                           ..translate(d_x, d_y),
//                         child: Container(
//                           decoration: BoxDecoration(image: DecorationImage(image: Image.file(File(widget.files[index])).image, fit: BoxFit.contain)),
//                         ),
//                       ),
//                     )),
//               ),
//               Center(
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     // SvgPicture.asset(
//                     //   "assets/icons/chevronBack.svg",
//                     //   height: 31,
//                     //   width: 31,
//                     // ),
//                     index != 0
//                         ? ButtonTheme(
//                             minWidth: 31,
//                             padding: EdgeInsets.all(0),
//                             child: FlatButton(
//                                 child: SvgPicture.asset(
//                                   "assets/icons/chevronBack2.svg",
//                                   height: 31,
//                                   width: 31,
//                                   color: Color.fromRGBO(231, 231, 231, 1),
//                                 ),
//                                 onPressed: () {
//                                   print("back");
//                                   // diaryData.attachments.removeAt(index);
//                                   setState(() {
//                                     if (index > 0) {
//                                       index -= 1;
//                                     }
//                                   });
//                                 }),
//                           )
//                         : Container(),
//                     index != widget.files.length - 1
//                         ? ButtonTheme(
//                             minWidth: 31,
//                             padding: EdgeInsets.all(0),
//                             child: FlatButton(
//                                 child: SvgPicture.asset(
//                                   "assets/icons/chevronNext2.svg",
//                                   height: 31,
//                                   width: 31,
//                                   color: Color.fromRGBO(231, 231, 231, 1),
//                                 ),
//                                 onPressed: () {
//                                   print("next");
//                                   // diaryData.attachments.removeAt(index);
//                                   setState(() {
//                                     if (index < widget.files.length - 1) {
//                                       index += 1;
//                                     }
//                                   });
//                                 }),
//                           )
//                         : Container()
//                   ],
//                 ),
//               )
//             ],
//           ),
//         ));
//   }
// }

// class _InteractiveImageState extends State<ImageGallary> {
//   double scale = 0.0;
//   double _scaleFactor = 1.0;
//   double _baseScaleFactor = 1.0;
//   double _savedVal = 1.0;

//   double d_x = 0;
//   double d_y = 0;

//   double x1 = 0;
//   double y1 = 0;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Transform(
//           transform: Matrix4(
//             1,
//             0,
//             0,
//             0,
//             0,
//             1,
//             0,
//             0,
//             0,
//             0,
//             1,
//             0,
//             0,
//             0,
//             0,
//             1,
//           )
//             ..scale(_scaleFactor)
//             ..translate(d_x, d_y),
//           alignment: FractionalOffset.center,
//           child: GestureDetector(
//             // onPanUpdate: (details) {
//             //   setState(() {
//             //     y = y - details.delta.dx / 100;
//             //     x = x + details.delta.dy / 100;
//             //   });
//             // },
//             // onPanUpdate: (det) {
//             //   print(det.delta.dx);
//             //   setState(() {
//             //     d_x += det.delta.dx;
//             //   });
//             // },
//             onScaleStart: (details) {
//               _baseScaleFactor = _scaleFactor;
//               x1 = details.focalPoint.dx;
//               y1 = details.focalPoint.dy;
//             },
//             onScaleUpdate: (details) {
//               // print(_scaleFactor);
//               // print(details.focalPoint.dx);
//               setState(() {
//                 if (_scaleFactor >= 1) {
//                   _scaleFactor = _baseScaleFactor * details.scale;
//                 }
//                 print(details.focalPoint.dx);
//                 // d_x = details.focalPoint.dx;
//                 d_x = (details.focalPoint.dx-x1)/_scaleFactor;
//                 d_y = (details.focalPoint.dy-y1)/_scaleFactor;
//               });
//             },
//             child: Container(
//               decoration: BoxDecoration(image: DecorationImage(image: Image.file(File(widget.files[0])).image, fit: BoxFit.scaleDown)),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _InteractiveImageState extends State<ImageGallary> {
//   double x = 0;
//   double y = 0;
//   double z = 0;
//   double sf = 1;

//   Widget build(BuildContext context) {
//     final ValueNotifier<Matrix4> notifier = ValueNotifier(Matrix4.identity());
//     return Scaffold(
//       backgroundColor: Colors.grey,
//       appBar: AppBar(
//         title: Text('Transform Demo'),
//       ),
//       body: MatrixGestureDetector(
//         shouldRotate: false,

//         onMatrixUpdate: (m, tm, sm, rm) {
//           notifier.value = m;
//         },
//         child: AnimatedBuilder(
//           animation: notifier,
//           builder: (ctx, child) {
//             return Transform(
//               transform: notifier.value,
//               child: Container(
//                 decoration: BoxDecoration(image: DecorationImage(image: Image.file(File(widget.files[0])).image, fit: BoxFit.scaleDown)),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

// class ImageGallary extends StatefulWidget {
//   final List<String> files;

//   ImageGallary({Key key, this.files}) : super(key: key);

//   @override
//   _PitCarouselDemoState createState() => _PitCarouselDemoState();
// }

// class _PitCarouselDemoState extends State<ImageGallary> {
//   // List<Widget> images = [Image.file(File("/storage/emulated/0/Pictures/lol/shot0001.png")), Image.file(File("/storage/emulated/0/Pictures/lol/shot0002.png"))];
//   List<String> images = ["/storage/emulated/0/Pictures/lol/shot0001.png", "/storage/emulated/0/Pictures/lol/shot0002.png"];

//   @override
//   void initState() {
//     super.initState();
//     // print(widget.files);
//     // for(int i=0; i<2; i++){
//     //   images.add(Image.file(File(widget.files[i])));
//     // }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Plugin example app'),
//         ),
//         body: AdvCarousel(
//           children: images,
//           dotAlignment: Alignment.topLeft,
//           height: double.infinity,
//           animationCurve: Curves.easeIn,
//           autoPlay: false,
//           repeat: false,
//         ),
//       ),
//     );
//   }
// }

// //import 'package:flutter/material.dart';

// // class Dashboard extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text(
// //           'Dashboard',
// //           textAlign: TextAlign.start,
// //           overflow: TextOverflow.clip,
// //           style: TextStyle(
// //             fontWeight: FontWeight.w700,
// //             fontStyle: FontStyle.normal,
// //             fontSize: 22,
// //             color: Color(0xffffffff),
// //           ),
// //         ),
// //         centerTitle: true,
// //         actions: [
// //           IconButton(
// //             icon: const Icon(Icons.person_add_sharp),
// //             onPressed: () {
// //               Navigator.pushReplacementNamed(context, '/registrasi');
// //             },
// //           ),
// //         ],
// //         backgroundColor: Color.fromARGB(255, 47, 108, 133),
// //       ),
// //     );
// //   }
// // }

// ///File download from FlutterViz- Drag and drop a tools. For more details visit https://flutterviz.io/

// import 'package:flutter/material.dart';
// import 'package:kasir/registrasi.dart';

// class dashboard extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xffe2e5e7),
//       body: SingleChildScrollView(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisSize: MainAxisSize.max,
//           children: [
//             Stack(
//               alignment: Alignment.topLeft,
//               children: [
//                 Container(
//                   margin: EdgeInsets.all(0),
//                   padding: EdgeInsets.all(0),
//                   width: MediaQuery.of(context).size.width,
//                   height: MediaQuery.of(context).size.height * 0.4,
//                   decoration: BoxDecoration(
//                     color: Color(0xff305186),
//                     shape: BoxShape.rectangle,
//                     borderRadius: BorderRadius.zero,
//                     border: Border.all(color: Color(0x4d9e9e9e), width: 1),
//                   ),
//                 ),
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisSize: MainAxisSize.max,
//                   children: [
//                     Padding(
//                       padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         mainAxisSize: MainAxisSize.max,
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisSize: MainAxisSize.max,
//                             children: [
//                               Text(
//                                 "DASH",
//                                 textAlign: TextAlign.start,
//                                 overflow: TextOverflow.clip,
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.w700,
//                                   fontStyle: FontStyle.normal,
//                                   fontSize: 22,
//                                   color: Color(0xffffffff),
//                                 ),
//                               ),
//                               Text(
//                                 "BOARD",
//                                 textAlign: TextAlign.start,
//                                 overflow: TextOverflow.clip,
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.w700,
//                                   fontStyle: FontStyle.normal,
//                                   fontSize: 22,
//                                   color: Color(0xff8bbeec),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),

//                     Padding(
//                       padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
//                       child: TextField(
//                         controller: TextEditingController(),
//                         obscureText: false,
//                         textAlign: TextAlign.start,
//                         maxLines: 1,
//                         style: TextStyle(
//                           fontWeight: FontWeight.w400,
//                           fontStyle: FontStyle.normal,
//                           fontSize: 14,
//                           color: Color(0xffffffff),
//                         ),
//                         decoration: InputDecoration(
//                           disabledBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12.0),
//                             borderSide:
//                                 BorderSide(color: Color(0x00ffffff), width: 1),
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12.0),
//                             borderSide:
//                                 BorderSide(color: Color(0x00ffffff), width: 1),
//                           ),
//                           enabledBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12.0),
//                             borderSide:
//                                 BorderSide(color: Color(0x00ffffff), width: 1),
//                           ),
//                           hintText: "Type Something...",
//                           hintStyle: TextStyle(
//                             fontWeight: FontWeight.w300,
//                             fontStyle: FontStyle.normal,
//                             fontSize: 13,
//                             color: Color(0xdec1e6f2),
//                           ),
//                           filled: true,
//                           fillColor: Color(0x915582b8),
//                           isDense: true,
//                           contentPadding:
//                               EdgeInsets.symmetric(vertical: 8, horizontal: 12),
//                           prefixIcon: Icon(Icons.search,
//                               color: Color(0x55ffffff), size: 20),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             Container(
//               margin: EdgeInsets.all(0),
//               padding: EdgeInsets.all(0),
//               height: 100,
//               decoration: BoxDecoration(
//                 color: Color(0x1fffffff),
//                 shape: BoxShape.rectangle,
//                 borderRadius: BorderRadius.zero,
//               ),
//             ),
//             Align(
//               alignment: Alignment(-0.1, 0.1),
//               child: GridView(
//                 padding: EdgeInsets.fromLTRB(15, 0, 15, 15),
//                 shrinkWrap: true,
//                 scrollDirection: Axis.vertical,
//                 physics: NeverScrollableScrollPhysics(),
//                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 3,
//                   crossAxisSpacing: 8,
//                   mainAxisSpacing: 8,
//                   childAspectRatio: 0.8,
//                 ),
//                 children: [
//                   Container(
//                     alignment: Alignment.center,
//                     margin: EdgeInsets.all(0),
//                     padding: EdgeInsets.all(0),
//                     width: 200,
//                     height: 100,
//                     decoration: BoxDecoration(
//                       color: Color(0x00000000),
//                       shape: BoxShape.rectangle,
//                       borderRadius: BorderRadius.zero,
//                     ),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       mainAxisSize: MainAxisSize.max,
//                       children: [
//                         Container(
//                           alignment: Alignment.center,
//                           margin: EdgeInsets.all(0),
//                           padding: EdgeInsets.all(0),
//                           width: 70,
//                           height: 70,
//                           decoration: BoxDecoration(
//                             color: Color(0xffffffff),
//                             shape: BoxShape.rectangle,
//                             borderRadius: BorderRadius.circular(8.0),
//                           ),
//                         ),
//                         Padding(
//                           padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
//                           child: Text(
//                             "Produk",
//                             textAlign: TextAlign.start,
//                             overflow: TextOverflow.clip,
//                             style: TextStyle(
//                               fontWeight: FontWeight.w400,
//                               fontStyle: FontStyle.normal,
//                               fontSize: 14,
//                               color: Color(0xff000000),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Container(
//                     alignment: Alignment.center,
//                     margin: EdgeInsets.all(0),
//                     padding: EdgeInsets.all(0),
//                     width: 200,
//                     height: 100,
//                     decoration: BoxDecoration(
//                       color: Color(0x00000000),
//                       shape: BoxShape.rectangle,
//                       borderRadius: BorderRadius.zero,
//                     ),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       mainAxisSize: MainAxisSize.max,
//                       children: [
//                         Container(
//                           alignment: Alignment.center,
//                           margin: EdgeInsets.all(0),
//                           padding: EdgeInsets.all(0),
//                           width: 70,
//                           height: 70,
//                           decoration: BoxDecoration(
//                             color: Color(0xffffffff),
//                             shape: BoxShape.rectangle,
//                             borderRadius: BorderRadius.circular(8.0),
//                           ),
//                         ),
//                         Padding(
//                           padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
//                           child: Text(
//                             "Pelanggan",
//                             textAlign: TextAlign.start,
//                             overflow: TextOverflow.clip,
//                             style: TextStyle(
//                               fontWeight: FontWeight.w400,
//                               fontStyle: FontStyle.normal,
//                               fontSize: 14,
//                               color: Color(0xff000000),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Container(
//                     alignment: Alignment.center,
//                     margin: EdgeInsets.all(0),
//                     padding: EdgeInsets.all(0),
//                     width: 200,
//                     height: 100,
//                     decoration: BoxDecoration(
//                       color: Color(0x00000000),
//                       shape: BoxShape.rectangle,
//                       borderRadius: BorderRadius.zero,
//                     ),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       mainAxisSize: MainAxisSize.max,
//                       children: [
//                         Container(
//                           alignment: Alignment.center,
//                           margin: EdgeInsets.all(0),
//                           padding: EdgeInsets.all(0),
//                           width: 70,
//                           height: 70,
//                           decoration: BoxDecoration(
//                             color: Color(0xffffffff),
//                             shape: BoxShape.rectangle,
//                             borderRadius: BorderRadius.circular(8.0),
//                           ),
//                         ),
//                         Padding(
//                           padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
//                           child: Text(
//                             "Penjualan",
//                             textAlign: TextAlign.start,
//                             overflow: TextOverflow.clip,
//                             style: TextStyle(
//                               fontWeight: FontWeight.w400,
//                               fontStyle: FontStyle.normal,
//                               fontSize: 14,
//                               color: Color(0xff000000),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Container(
//                     alignment: Alignment.center,
//                     margin: EdgeInsets.all(0),
//                     padding: EdgeInsets.all(0),
//                     width: 200,
//                     height: 100,
//                     decoration: BoxDecoration(
//                       color: Color(0x00000000),
//                       shape: BoxShape.rectangle,
//                       borderRadius: BorderRadius.zero,
//                     ),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       mainAxisSize: MainAxisSize.max,
//                       children: [
//                         Container(
//                           alignment: Alignment.center,
//                           margin: EdgeInsets.all(0),
//                           padding: EdgeInsets.all(0),
//                           width: 70,
//                           height: 70,
//                           decoration: BoxDecoration(
//                             color: Color(0xffffffff),
//                             shape: BoxShape.rectangle,
//                             borderRadius: BorderRadius.circular(8.0),
//                           ),
//                         ),
//                         Padding(
//                           padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
//                           child: Text(
//                             "Registrasi",
//                             textAlign: TextAlign.start,
//                             overflow: TextOverflow.clip,
//                             style: TextStyle(
//                               fontWeight: FontWeight.w400,
//                               fontStyle: FontStyle.normal,
//                               fontSize: 14,
//                               color: Color(0xff000000),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

///File download from FlutterViz- Drag and drop a tools. For more details visit https://flutterviz.io/

import 'package:flutter/material.dart';

class dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      appBar: AppBar(
        elevation: 4,
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xff3a57e8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        title: Text(
          "Homepage",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.normal,
            fontSize: 20,
            color: Color(0xffffffff),
          ),
        ),
        leading: Icon(
          Icons.list,
          color: Color(0xffffffff),
          size: 24,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 0, 0),
              child: Text(
                "Folders",
                textAlign: TextAlign.start,
                overflow: TextOverflow.clip,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.normal,
                  fontSize: 16,
                  color: Color(0xff000000),
                ),
              ),
            ),
            GridView(
              padding: EdgeInsets.all(16),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              physics: ClampingScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1,
              ),
              children: [
                Card(
                  margin: EdgeInsets.all(0),
                  color: Color(0xffffffff),
                  shadowColor: Color(0xff000000),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.all(0),
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Color(0x2d3a57e8),
                          shape: BoxShape.circle,
                          border:
                              Border.all(color: Color(0x4d9e9e9e), width: 1),
                        ),
                        child: Icon(
                          Icons.all_inclusive,
                          color: Color.fromARGB(255, 39, 101, 151),
                          size: 24,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 12, 0, 8),
                        child: Text(
                          "Produk",
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.normal,
                            fontSize: 16,
                            color: Color(0xff000000),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Card(
                  margin: EdgeInsets.all(0),
                  color: Color(0xffffffff),
                  shadowColor: Color(0xff000000),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.all(0),
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Color(0x2d3a57e8),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.access_time,
                          color: Color(0xff3a57e8),
                          size: 24,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 12, 0, 8),
                        child: Text(
                          "Current Tasks",
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.normal,
                            fontSize: 16,
                            color: Color(0xff000000),
                          ),
                        ),
                      ),
                      Text(
                        "14 Tasks",
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          fontSize: 14,
                          color: Color(0xff363636),
                        ),
                      ),
                    ],
                  ),
                ),
                Card(
                  margin: EdgeInsets.all(0),
                  color: Color(0xffffffff),
                  shadowColor: Color(0xff000000),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.all(0),
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Color(0x2d3a57e8),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.alarm,
                          color: Color(0xff3a57e8),
                          size: 24,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 12, 0, 8),
                        child: Text(
                          "Next Tasks",
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.normal,
                            fontSize: 16,
                            color: Color(0xff000000),
                          ),
                        ),
                      ),
                      Text(
                        "2 Tasks",
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          fontSize: 14,
                          color: Color(0xff363636),
                        ),
                      ),
                    ],
                  ),
                ),
                Card(
                  margin: EdgeInsets.all(0),
                  color: Color(0xffffffff),
                  shadowColor: Color(0xff000000),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.all(0),
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Color(0x2d3a57e8),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.article,
                          color: Color(0xff3a57e8),
                          size: 24,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 12, 0, 8),
                        child: Text(
                          "Future Tasks",
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.normal,
                            fontSize: 16,
                            color: Color(0xff000000),
                          ),
                        ),
                      ),
                      Text(
                        "6 Tasks",
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          fontSize: 14,
                          color: Color(0xff363636),
                        ),
                      ),
                    ],
                  ),
                ),
                Card(
                  margin: EdgeInsets.all(0),
                  color: Color(0xffffffff),
                  shadowColor: Color(0xff000000),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.all(0),
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Color(0x2d3a57e8),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.verified,
                          color: Color(0xff3a57e8),
                          size: 24,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 12, 0, 8),
                        child: Text(
                          "Completed Tasks",
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.normal,
                            fontSize: 16,
                            color: Color(0xff000000),
                          ),
                        ),
                      ),
                      Text(
                        "10 Tasks",
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          fontSize: 14,
                          color: Color(0xff363636),
                        ),
                      ),
                    ],
                  ),
                ),
                Card(
                  margin: EdgeInsets.all(0),
                  color: Color(0xffffffff),
                  shadowColor: Color(0xff000000),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.all(0),
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Color(0x2d3a57e8),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.add,
                          color: Color(0xff3a57e8),
                          size: 24,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 12, 0, 8),
                        child: Text(
                          "New Folder",
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.normal,
                            fontSize: 16,
                            color: Color(0xff000000),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
